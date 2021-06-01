<?lsp

local ua = require("opcua.api")
local nodeIds = require("opcua.node_ids")

local function createBrowseParams(nodeId)
   return {
      requestedMaxReferencesPerNode = 0,
      nodesToBrowse = {
         {
            nodeId = nodeId,
            browseDirection = ua.Types.BrowseDirection.Forward,
            referenceTypeId = nodeIds.HierarchicalReferences,
            nodeClassMask = ua.Types.NodeClass.Unspecified,
            resultMask = ua.Types.BrowseResultMask.All,
            includeSubtypes = 1,
         }
      },
   }
end

local function createReadParams(nodeId)
   local nodeToRead = {}
   for _,attrId in pairs(ua.Types.AttributeId) do
      table.insert(nodeToRead, {nodeId=nodeId, attributeId=attrId})
   end

   return {
      nodesToRead = nodeToRead
   }
end

if request:header"Sec-WebSocket-Key" then
   trace"New WebSocket connection"
   local s = ba.socket.req2sock(request)
   if s then
      trace"Creating new UA client"
      trace"Reading data"
      local mergeConfig = require("opcua.config")

      trace("---------------------------------------------")
      local localConfig = io:dofile(".opcua_config")
      ua.Tools.printTable("Local configuration file", localConfig)

      trace("---------------------------------------------")
      defaultConfig = mergeConfig(localConfig)
      ua.Tools.printTable("Full OPCUA configuration", defaultConfig)

      uaClient = ua.newClient()

      local function wsCosocket()
         while true do
            local data,err = s:read()
            if data == nil then
               if "sysshutdown" ~= err then
                  trace("Failed to receive message:", err)
               end
               break
            end
            local resp = {}
            if data == nil then
               resp.error = "Empty request"
            else
               trace("new request: " .. data)
               local request = ba.json.decode(data)
               if request == nil then
                  resp.error = "Empty request body"
               else
                  if request.id == nil then
                     resp.error  = "Request has no 'id' field"
                  else
                     if request.connectEndpoint ~= nil then
                        trace("Received Connect request")
                        local conn = request.connectEndpoint

                        if conn.endpointUrl ~= nil then
                           trace("---------------------------------------------")
                           ua.Tools.printTable("Client configuration", conn)

                           trace("---------------------------------------------")
                           clienConfig = mergeConfig(conn, defaultConfig)
                           ua.Tools.printTable("Result configuration", clienConfig)

                           uaClient:connect(clienConfig)
                           uaClient:openSecureChannel(3600000)
                           uaClient:createSession("RTL Web client", 1200000)
                        else
                           trace("Error: client sent empty endpoint URL")
                           resp.error = "Empty endpointURL"
                        end
                     elseif request.browse ~= nil then
                        trace("Received Browse request")
                        trace("Browsing node: "..request.browse.nodeId)
                        local suc, result = pcall(uaClient.browse, uaClient, createBrowseParams(request.browse.nodeId))
                        if suc then
                           resp.browse = result.results
                        else
                           resp.error = result
                        end
                     elseif request.read ~= nil then
                        trace("Received Read request")
                        trace("Reading attribute of node: "..request.read.nodeId)
                        local suc, result = pcall(uaClient.read, uaClient, createReadParams(request.read.nodeId))
                        if suc then
                           trace("Read successfull")
                           resp.read = result.results
                        else
                           trace("Read failed")
                           resp.error = result
                        end
                     else
                        resp.error = "Unknown request"
                     end
                     resp.id = request.id
                  end
               end
            end
            data = ba.json.encode(resp)
            trace("sending response: ".. data)
            s:write(data, true)
         end

         s:close()
         trace("web-socket connection closed")
         return -- We are done
      end
      s:event(wsCosocket)
   end
end
?>
