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
            local securityPolicyUri = request.connectEndpoint.securityPolicyUri or ua.Types.SecurityPolicy.None
            local securityMode = request.connectEndpoint.securityMode or ua.Types.MessageSecurityMode.None
            local serverCertificate = request.connectEndpoint.serverCertificate
            if serverCertificate then
              serverCertificate = ba.b64decode(serverCertificate)
            end
          
            if endpointUrl then
               if uaClient then
                  trace"Closing UA client"
                  pcall(function()
                     uaClient:closeSession()
                     uaClient:disconnect()
                  end)
               end
               trace"Creating new UA client"
               clientConfig.cosocketMode = true
               ua.Tools.printTable("Client configuration", clientConfig)
               -- Cosocket mode will automatically be enabled since are we in cosocket context
               uaClient = ua.newClient(clientConfig)
               trace("Connecting to server")
               local suc, result = pcall(function()
                                            trace("Connecting to endpoint '".. endpointUrl .. "'")
                                            local err = uaClient:connect(endpointUrl)
                                            local session
                                            trace("Opening secureChannel")
                                            if not err then _,err = uaClient:openSecureChannel(3600000, securityPolicyUri, securityMode, serverCertificate) end
                                            trace("Creating Session")
                                            if not err then session,err = uaClient:createSession("RTL Web client", 1200000) end
                                            trace("Activating Session")
                                            if not err then _,err = uaClient:activateSession(session) end
                                            return err
                                         end)
               if not suc or result then
                  uaClient = nil
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
            elseif request.getEndpoints then
              trace("Selecting endpoints: ")
              local suc, result = pcall(uaClient.getEndpoints, uaClient, request.getEndpoints)
              for _,endpoint in ipairs(result.endpoints) do 
                if endpoint.serverCertificate then
                  endpoint.serverCertificate = ba.b64encode(endpoint.serverCertificate) -- Erase until because need to 
                end
              end
              if suc then
                resp.endpoints = result.endpoints
              else
                resp.error = result
              end
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
      local data = ba.json.encode(resp)
      wsSock:write(data, true)
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
