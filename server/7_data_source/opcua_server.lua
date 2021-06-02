-- Load the OPCUA API
local ua = require("opcua.api")
local nodeIds = require("opcua.node_ids")

-- New instance of an OPC UA server
-- Pass configuration table to server.
local server = ua.newServer(config)

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
local function initializeDataSource(services)
  trace("Adding a node into address space")

  local statusCode = 0
  local newVariableParams = ua.newVariableParams(
     nodeIds.ObjectsFolder, {name="CustomDataSource", ns=0}, "CustomDataSource", {float=1.0}, dataSouceId)
  local res = services:addNodes({nodesToAdd={newVariableParams}})
  for _,result in ipairs(res.results) do
    if result.statusCode ~= 0 then
      statusCode = result.statusCode
    end
  end

  if statusCode ~= 0 then
    error(statusCode)
  end
  trace("Setting address space")

  services:setVariableSource(dataSouceId, processDataSource)
end

-- Initialize server.
server:initialize(initializeDataSource)


-- Run server; start listening on port number.
server:run()

function onunload()
  trace("Stopping OPC-UA server")
  server:shutdown()
end
