-- Load an OPCUA API
local ua = require("opcua.api")

local ObjectsFolder = "i=85"
local TypesFolder = "i=86"
local Server_ServerStatus_CurrentTime = "i=2258"

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

-- Read all attributes of a node by its ID.
local attrs = server:read(ObjectsFolder)
ua.Tools.printTable("ObjectsFolder", attrs)

-- Read all attributes of a node by its ID.
local attrs = server:read({ObjectsFolder, TypesFolder, ViewsFolder})
ua.Tools.printTable("SeveralNodes", attrs)

-- Read only specified attributes of a node by its ID.

local requiredAttrs = {
  {nodeId = Server_ServerStatus_CurrentTime, attributeId=ua.Types.AttributeId.BrowseName},
  {nodeId = Server_ServerStatus_CurrentTime, attributeId=ua.Types.AttributeId.Value},
}

local attrs = server:read(requiredAttrs)
ua.Tools.printTable("CurrentTime", attrs)

-- Run server. Start listening to port
server:run()

function onunload()
   trace("Stopping server example 4")
   server:shutdown()
end
