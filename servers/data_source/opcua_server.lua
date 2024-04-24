-- Load the OPCUA API
local ua = require("opcua.api")

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

server:initialize()

-- Node ID of data source
local dataSouceId = "ns=3;s=custom_data_source"
-- Variable that will be returned to clients
local variable = 1

-- Callback function is being called each time a read or write request
-- is initiated by client
local function processDataSource(nodeId, value)
  if value == nil then
    variable = (variable < 10000000000) and variable * 13.13 or 1
    trace("Read value: ".. variable)
    return variable
  else
    trace("Write value: ".. value.float)
    variable = value.float
  end
end


-- A callback function that will be called for initialization purposes
-- when server is ready.
trace("Adding a node into address space")

local ObjectsFolder = "i=85"
local statusCode = 0
local newVariableParams = ua.newVariableParams(ObjectsFolder, "CustomDataSource", {Value={Float=1.0}}, dataSouceId)

local res = server:addNodes({NodesToAdd={newVariableParams}})
for _,result in ipairs(res.Results) do
  if result.StatusCode ~= 0 then
    statusCode = result.StatusCode
  end
end

if statusCode ~= 0 then
  error(statusCode)
end
trace("Setting address space")

server:setVariableSource(dataSouceId, processDataSource)

-- Run server; start listening on port number.
server:run()

function onunload()
  trace("Stopping OPC-UA server")
  server:shutdown()
end
