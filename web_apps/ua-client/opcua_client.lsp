<?lsp

local ua = require("opcua.api")
local nodeIds = require("opcua.node_ids")

local function uaProcessRequest(ctx, payload)
   local request = ba.json.decode(payload)

   local resp = {
      id = request.id
   }

   if request == nil then
      resp.error = "Empty request body"
   end

   if request.id == nil then
      resp.error  = "Request has no 'id' field"
   else
      if request.connectEndpoint ~= nil then
         trace("Received Connect request")
         local conn = request.connectEndpoint

         if conn.endpointUrl ~= nil then
            trace"Creating new UA client"
            local mergeConfig = require("opcua.config")
      
            trace("---------------------------------------------")
            local localConfig = io:dofile(".opcua_config")
            ua.Tools.printTable("Local configuration file", localConfig)
      
            trace("---------------------------------------------")
            defaultConfig = mergeConfig(localConfig)
            ua.Tools.printTable("Full OPCUA configuration", defaultConfig)

            trace("---------------------------------------------")
            ua.Tools.printTable("Client configuration", conn)

            trace("---------------------------------------------")
            clienConfig = mergeConfig(conn, defaultConfig)
            ua.Tools.printTable("Result configuration", clienConfig)
            local uaClient = ua.newClient(clienConfig)
            ctx.uaClient = uaClient
            local suc, result = pcall(function() 
               uaClient:connect()
               uaClient:openSecureChannel(3600000)
               uaClient:createSession("RTL Web client", 1200000)
            end)
            if not suc then
               resp.error = result
            end
         else
            trace("Error: client sent empty endpoint URL")
            resp.error = "Empty endpointURL"
         end
      elseif request.browse ~= nil then
         trace("Browsing node: "..request.browse.nodeId)
         local suc, result = pcall(ctx.uaClient.browse, ctx.uaClient, request.browse.nodeId)
         if suc then
            resp.browse = result.results
         else
            resp.error = result
         end
      elseif request.read ~= nil then
         trace("Reading attribute of node: "..request.read.nodeId)
         local suc, result = pcall(ctx.uaClient.read, ctx.uaClient, request.read.nodeId)
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
   end

   return ba.json.encode(resp)
end

local uaThread = ba.thread.create()

if request:header"Sec-WebSocket-Key" then
   trace"New WebSocket connection"
   local s = ba.socket.req2sock(request)
   if s then
      local threadContext = {}

      local function wsCosocket()
         while true do
            local data,err = s:read()
            if err == "sysshutdown" then
               trace("Failed to receive message:", err)
               break
            end

            trace("new request: " .. data)
            local resp
            uaThread:run(function()
               resp = uaProcessRequest(threadContext, data)
               s:enable()
            end)
            s:disable()

            trace("sending response: ".. resp)
            s:write(resp, true)
         end

         s:close()
         trace("web-socket connection closed")
         return -- We are done
      end
      s:event(wsCosocket)
   end
end
?>
