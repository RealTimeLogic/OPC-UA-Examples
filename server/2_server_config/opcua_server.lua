-- Load an OPCUA API
local ua = require("opcua.api")

local config = {
   listenPort = 4841,
   listenAddress = "localhost", -- '*' to listen on all interfaces
   endpointUrl = "opc.tcp://localhost:4841", -- Endpoint URL is used by clients to establish secure channel.

   logging = {
    socket = {
      dbgOn = true,
      infOn = true,
      errOn = true,
    },
    binary = {
      dbgOn = true,
      infOn = true,
      errOn = true,
    },
    services = {
      dbgOn = false,
      infOn = true,
      errOn = true,
    }
  }
}

-- New instance of an OPC UA server
-- Pass configuration table to server.
local server = ua.newServer(config)

-- Initialize server.
server:initialize()

-- Run server. Start listening to port
server:run()

function onunload()
  trace("Stopping server example 1")
  server:shutdown()
end
