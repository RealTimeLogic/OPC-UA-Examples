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

-- add Folder node
local request = {
  NodesToAdd = {
     ua.newFolderParams(ObjectsFolder, "NewFolder")
   }
}

local resp, err = server:addNodes(request)
local res = resp.Results
if res[1].StatusCode ~= ua.StatusCode.Good and res[1].StatusCode ~= ua.StatusCode.BadNodeIdExists then
 error(res.StatusCode)
end

local folderId = res[1].AddedNodeId

-- Add two variables:
--   1. Boolean scalar value
--   2. Boolean array value

-- required Node ID for variable
local scalarBooleanId = "i=1000000"

-- Initial boolean scalar value
local scalarBoolean = {
  Type = ua.Types.VariantType.Boolean,
  Value = true
}

local arrBooleanId = "i=1000001"
-- Initial boolean array value
local arrBoolean = {
  Type = ua.Types.VariantType.Boolean,
  IsArray = true,
  Value = {true, false, true, false}
}

local request = {
    NodesToAdd = {
    ua.newVariableParams(folderId, "boolean", scalarBoolean, scalarBooleanId),
    ua.newVariableParams(folderId, "boolean_array", arrBoolean, arrBooleanId),
  }
}

local resp, err = server:addNodes(request)
local res = resp.Results
if res[1].StatusCode ~= ua.StatusCode.Good and res[1].StatusCode ~= ua.StatusCode.BadNodeIdExists then
  error(res.StatusCode)
end

-- Run server. Start listening to port
server:run()

function onunload()
   trace("Stopping server example 5")
   server:shutdown()
end
