-- Load an OPCUA API
local ua = require("opcua.api")

-- Create server configuration table

local config = {
  -- listenPort=4841,
  -- listenAddress="*",
  -- endpointUrl = "opc.tcp://loclahost:4841"

  listenPort=4841,
  listenAddress="*",
  endpointUrl="opc.tcp://localhost:4841",

  securityPolicyUri = ua.Types.SecurityPolicy.None,
  bufSize = 16384,
  logging = {
    socket = {
      dbgOn = true,  -- debug logs of socket
      infOn = true,  -- information logs about sockets
      errOn = true   -- Errors on sockets
    },
    binary = {
      dbgOn = true,  -- Debugging traces about binary protocol. Print encoded message hex data.
      infOn = true,  -- Information traces about binary protocol
      errOn = true   -- Errors in binary protocol
    },
    services = {
      dbgOn = true,  -- Debugging traces about UA services work
      infOn = true,  -- Informations traces
      errOn = true   -- Errors
    }
  }

}

-- New instance of an OPC UA server
local server = ua.newServer(config)

-- Initialize and load addons if addon function provided.
server:initialize(DemoAddon)

-- Run server. Starts to listen ports
server:run()

-- Server starts asynchroniously so we can do another (un)usefull work.
while true do
    ba.sleep(1000)
end
