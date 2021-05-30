-- Load an OPCUA API
local ua = require("opcua.api")
local nodeIds = require("opcua.node_ids")

-- New instance of an OPC UA server
-- Pass configuration table to server.
local server = ua.newServer(config)

-- Node ID of data source
local dataSouceId = "ns=3;s=custom_data_source"
-- Variable that will be returned to clients
local variable = 1

-- Callback function is being called when read or write request will be processed
local function processDataSource(nodeId, value)
  if value == nil then
    variable = (variable < 10000000000) and variable * 13.13 or 1
    print("Read value: ".. variable)
    return variable
  else
    print("Writting value: ".. value.float)
    variable = value.float
  end
end


-- A function that will be called for initialization when server is becoming ready.
local function initializeDataSource(services)
  print("Adding a node into address space")

  local statusCode = 0
  local newVariableParams = ua.newVariableParams(nodeIds.ObjectsFolder, {name="CustomDataSource", ns=0}, "CustomDataSource", {float=1.0}, dataSouceId)
  local res = services:addNodes({nodesToAdd={newVariableParams}})
  for _,result in ipairs(res.results) do
    if result.statusCode ~= 0 then
      statusCode = result.statusCode
    end
  end

  if statusCode ~= 0 then
    error(statusCode)
  end
  print("Setting address space")

  services:setVariableSource(dataSouceId, processDataSource)
end

-- Initialize server.
server:initialize(initializeDataSource)


-- Run server. Start listening to port
server:run()

function onunload()
  trace("Stopping OPC-UA server")
  server:shutdown()
end
