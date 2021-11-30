<?lsp

local ua = require("opcua.api")

local function opcUaClient(wsSock)
   local uaClient
   while true do
      local data,err = wsSock:read()
      if not data then
         trace("WS close:",err)
         break
      end
      local request = ba.json.decode(data)
      local resp = { id = request and request.id }
      if request then
         if request.connectEndpoint then
            trace("Received Connect request")
            local endpointUrl = request.connectEndpoint.endpointUrl
            if endpointUrl then
               if uaClient then
                  trace"Closing UA client"
                  pcall(function()
                     uaClient:closeSession()
                     uaClient:disconnect()
                  end)
               end
               trace"Creating new UA client"
               ua.Tools.printTable("Client configuration", config)
               -- Cosocket mode will automatically be enabled since are we in cosocket context
               uaClient = ua.newClient()
               trace("Connecting to server")
               local suc, result = pcall(function() 
                                            local err
                                            err = uaClient:connect(endpointUrl)
                                            if not err then _,err = uaClient:openSecureChannel(3600000) end
                                            if not err then _,err = uaClient:createSession("RTL Web client", 1200000) end
                                            if not err then _,err = uaClient:activateSession() end
                                            return err
                                         end)
               if not suc or result then
                  trace("Connection failed: ", result)
                  resp.error = result
               else
                  trace("Connected")
               end
            else
               trace("Error: client sent empty endpoint URL")
               resp.error = "Empty endpointURL"
            end
         else
            if not uaClient then
               resp.error = "OPC UA Client not connected"
            elseif request.browse then
               trace("Browsing node: "..request.browse.nodeId)
               local suc, result = pcall(uaClient.browse, uaClient, request.browse.nodeId)
               if suc then
                  resp.browse = result.results
               else
                  resp.error = result
               end
            elseif request.read then
               trace("Reading attribute of node: "..request.read.nodeId)
               local suc, result = pcall(uaClient.read, uaClient, request.read.nodeId)
               if suc then
                  trace("Read successfull")
                  resp.read = result.results
               else
                  trace("Read failed")
                  resp.error = result
               end
            else
               resp.error = "Unknown request type"
            end
         end
      else
         resp.error = "JSON parse error"
      end
      wsSock:write(ba.json.encode(resp), true)
   end

   if uaClient then
      trace"Closing UA client"
      pcall(function()
         uaClient:closeSession()
         uaClient:disconnect()
      end)
   end

end


if request:header"Sec-WebSocket-Key" then
   trace"New WebSocket connection"
   local s = ba.socket.req2sock(request)
   if s then
      s:event(opcUaClient,"s")
      return
   end
end
response:senderror(404)
?>
