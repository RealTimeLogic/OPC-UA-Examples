-- Load an OPCUA API
local ua = require("opcua.api")

-- Minimum configuration of server
local config = {
  endpoints = {
    {
      endpointUrl="opc.tcp://localhost:4841",
    }
  },

  securePolicies ={
    { -- #1
      securityPolicyUri = "http://opcfoundation.org/UA/SecurityPolicy#None",
    }
  },
}

-- New instance of an OPC UA server
local server = ua.newServer(config)

-- Initialize server.
server:initialize()

-- Run server. Start listening to ports
server:run()


function onunload()
   trace("Stopping server example 1")
   server:shutdown()
end
