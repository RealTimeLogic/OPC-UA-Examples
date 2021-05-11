-- require("ldbgmon").connect{client=false}

-- Load an OPCUA API
local ua = require("opcua.api")
local nodeIds = require("opcua.node_ids")

-- New instance of an OPC UA server
-- Pass configuration table to server.
local server = ua.newServer()

-- Initialize server.
server:initialize()



-- Add variable node
local variableNodeId = "i=1000000"
local value = {int64 = 0}
local variableParams = ua.newVariableParams(nodeIds.ObjectsFolder, {name="variable", ns=0}, "variable", value, variableNodeId)
local resp = server.services:addNodes({nodesToAdd={variableParams}})
local res = resp.results
if res[1].statusCode ~= ua.Status.Good and res[1].statusCode ~= ua.Status.BadNodeIdExists then
  error(res.statusCode)
end

-- Update value of the added variable
local nodes = {
  nodesToWrite = {
    {
      nodeId = variableNodeId,
      attributeId = ua.Types.AttributeId.Value,
      value = {
        value = {
          int64 = 1
        }
      }
    }
  }
}

local resp = server:write(nodes)
ua.Tools.printTable("Write Result", resp)

-- Run server. Start listening on default OPC-UA port
server:run()


-- Create a timer that increments the int64 value every second

local function timerFunc()
   local value = nodes.nodesToWrite[1].value.value
   while true do
      value.int64 = value.int64 + 1
      local resp = server:write(nodes)
      if resp.results[1] == ua.Status.Good then
         trace("value.int64=",value.int64)
      else
         trace("Updating node failed!")
      end
      coroutine.yield(true)
   end
end
 
local timer = ba.timer(timerFunc)
timer:set(1000)

function onunload()
   trace("Stopping server example 6")
   timer:cancel()
end
