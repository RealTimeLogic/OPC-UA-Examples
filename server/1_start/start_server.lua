-- Load an OPCUA API
local ua = require("opcua.api")

-- New instance of an OPC UA server
local server = ua.newServer()

-- Initialize server.
server:initialize()

-- Run server. Start listening to ports
server:run()
