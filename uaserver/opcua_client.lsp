<?lsp

if request:header"Sec-WebSocket-Key" then
  trace"New WebSocket connection"
  local s = ba.socket.req2sock(request)
  if s then
    trace"Creating new UA client"
    local c = app.UaClient
    trace"Reading data"
    while true do
      local data,err = s:read()
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
--[[
            if request.connect ~= nil then
              trace("Received Connect request")
              local conn = request.connect
              if conn.endpointUrl ~= nil then
                trace("Connecting to endpoint "..conn.endpointUrl)
                resp.error = c:Connect(conn.endpointUrl)
              else
                trace("Error: client sent empty endpoint URL")
                resp.error = "Empty endpointURL"
              end
            end
]]
            if request.browse ~= nil then
              trace("Received Browse request")
              trace("Browsing node: "..request.browse.nodeId)
              resp.error,resp.browse = c:Browse(request.browse.nodeId)
            elseif request.read ~= nil then
              trace("Received Read request")
              trace("Reading attribute of node: "..request.read.nodeId)
              resp.error,resp.read = c:Read(request.read.nodeId)
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
    return -- We are done
  end
end
?>
