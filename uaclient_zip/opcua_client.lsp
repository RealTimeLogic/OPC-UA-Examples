<?lsp

if request:header"Sec-WebSocket-Key" then
  trace"New WebSocket connection"
  local s = ba.socket.req2sock(request)
  if s then
    trace"Creating new UA client"
    trace"Reading data"
    local ua = require("opcua.api")
    uaClient = ua.newClient()

    while true do
      local data,err = s:read()
      if data == nil then
        trace("Failed to receive message:", err)
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
                uaClient:connect(conn)
                uaClient:createSession("RTL Web client", 1200000)
              else
                trace("Error: client sent empty endpoint URL")
                resp.error = "Empty endpointURL"
              end
            elseif request.browse ~= nil then
              trace("Received Browse request")
              trace("Browsing node: "..request.browse.nodeId)
              local suc, result = pcall(uaClient.browse, uaClient, request.browse.nodeId)
              if suc then
                resp.browse = result
              else
                resp.error = result
              end
            elseif request.read ~= nil then
              trace("Received Read request")
              trace("Reading attribute of node: "..request.read.nodeId)
              local suc, result = pcall(uaClient.read, uaClient, request.read.nodeId)
              if suc then
                resp.read = result
              else
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
end
?>
