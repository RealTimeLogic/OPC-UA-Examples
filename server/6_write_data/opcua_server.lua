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

local result = server:write(nodes)
ua.Tools.printTable("Write Result", result)

-- Run server. Start listening to port
server:run()
