-- Load an OPCUA API
local ua = require("opcua.api")

local ObjectsFolder = "i=85"

local function addFolderNode(services)
  local request = {
     nodesToAdd = {
        ua.newFolderParams(ObjectsFolder, {name="NewFolder", ns=0}, "NewFolder")
      }
  }

  local resp = services:addNodes(request)
  local res = resp.results
  if res[1].statusCode ~= ua.StatusCode.Good and res[1].statusCode ~= ua.StatusCode.BadNodeIdExists then
    error(res.statusCode)
  end

  return res[1].addedNodeId
end


-- Add two variables:
--   1. Boolean scalar value
--   2. Boolean array value
local function addVariables(services, parentNodeId)
  -- required Node ID for variable
  local scalarBooleanId = "i=1000000"

  -- Initial boolean scalar value
  local scalarBoolean = {
    boolean = true
  }

  local arrBooleanId = "i=1000001"
  -- Initial boolean array value
  local arrBoolean = {
    boolean = {true, false, true, false}
  }

  local request = {
     nodesToAdd = {
      ua.newVariableParams(parentNodeId, {name="scalar", ns=0}, "boolean", scalarBoolean, scalarBooleanId),
      ua.newVariableParams(parentNodeId, {name="array", ns=0}, "boolean_array", arrBoolean, arrBooleanId),
    }
  }

  local resp = services:addNodes(request)
  local res = resp.results
  if res[1].statusCode ~= ua.StatusCode.Good and res[1].statusCode ~= ua.StatusCode.BadNodeIdExists then
    error(res.statusCode)
  end
end

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
local folderId = addFolderNode(server.services)
addVariables(server.services, folderId)

-- Run server. Start listening to port
server:run()

function onunload()
   trace("Stopping server example 5")
   server:shutdown()
end
