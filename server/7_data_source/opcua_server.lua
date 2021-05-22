-- Load an OPCUA API
local ua = require("opcua.api")
local nodeIds = require("opcua.node_ids")

-- New instance of an OPC UA server
-- Pass configuration table to server.
local server = ua.newServer()

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

  local newVariableParams = {
    parentNodeId = nodeIds.ObjectsFolder,
    referenceTypeId = nodeIds.Organizes,
    requestedNewNodeId = dataSouceId,
    browseName = {name="browseName", ns=0},
    nodeClass = ua.Types.NodeClass.Variable,
    nodeAttributes = {
      typeId = "i=357",
      body = {
        specifiedAttributes = ua.Types.VariableAttributesMask,
        displayName = {text="CustomDataSource"},
        description = {text="An example of callback for reading/writing data"},
        writeMask = 0,
        userWriteMask = 0,
        value = {float=variable},
        dataType = nodeIds.Float,
        valueRank = ua.Types.ValueRank.Scalar,
        arrayDimensions = nil,
        accessLevel = 0,
        userAccessLevel = 0,
        minimumSamplingInterval = 1000,
        historizing = 0
      }
    },
    typeDefinition = nodeIds.BaseDataVariableType
  }

  services:addNodes({nodesToAdd={newVariableParams}})

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

