-- require("ldbgmon").connect{client=false}

-- Load an OPCUA API
local ua = require("opcua.api")
local ObjectsFolder = "i=85"

-- New instance of an OPC UA server
-- Pass configuration table to server.
local config = {
  endpointUrl="opc.tcp://localhost:4841",
  securePolicies ={
    { -- #1
      securityPolicyUri = "http://opcfoundation.org/UA/SecurityPolicy#None",
    }
  },
}
local server = ua.newServer(config)

-- Initialize server.
server:initialize()



-- Add variable node
local variableNodeId = "i=1000000"
local value = {Value={Int64 = 0}}
local variableParams = ua.newVariableParams(ObjectsFolder, "variable", value, variableNodeId)
local resp = server.services:addNodes({NodesToAdd={variableParams}})
local res = resp.Results
if res[1].StatusCode ~= ua.StatusCode.Good and res[1].StatusCode ~= ua.StatusCode.BadNodeIdExists then
  error(res.StatusCode)
end

-- Update value of the added variable
local nodes = {
  NodesToWrite = {
    {
      NodeId = variableNodeId,
      AttributeId = ua.Types.AttributeId.Value,
      Value = {
        Value = {
          Int64 = 1
        }
      }
    }
  }
}

local resp = server:write(nodes)
ua.Tools.printTable("Write Result", resp)

-- Run server. Start listening on default OPC-UA port
server:run()

function onunload()
  trace("Stopping server example 1")
  server:shutdown()
end


-- Create a timer that increments the int64 value every second

local function timerFunc()
   local value = nodes.nodesToWrite[1].value.value
   while true do
      value.int64 = value.int64 + 1
      local resp = server:write(nodes)
      if resp.results[1] == ua.StatusCode.Good then
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
   server:shutdown()
end
