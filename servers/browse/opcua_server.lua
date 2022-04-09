-- Load an OPCUA API
local ua = require("opcua.api")
local nodeIds = require("opcua.node_ids")

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

-- browse Objects folder
local resp = server:browse(nodeIds.ObjectsFolder)
local children = resp.results
ua.Tools.printTable("ObjectsRoot", children)

local childIDs = {}
-- Browse children nodes
for i,child in ipairs(children[1].references) do
  table.insert(childIDs, child.nodeId)
end

local children = server:browse(childIDs)
ua.Tools.printTable("children", children)


-- Run server. Start listening to port
server:run()

function onunload()
   trace("Stopping server example 3")
   server:shutdown()
end
