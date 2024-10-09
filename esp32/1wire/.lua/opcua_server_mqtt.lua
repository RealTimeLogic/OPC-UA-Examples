--[[

This example application reads temperature from DS18B20 sensor.
Temperature value is written to node in OPCUA server.
OPCUA server monitors changes in node values and publishes it to MQTT broker.

]]

local GPIO_PIN <const> = 4 -- GPIO pin where DS18B20 sensor is connected

-- Load an OPCUA API
local ua = require("opcua.api")
local readTemp = require("ds18b20")

-- New instance of an OPC UA server
-- Pass configuration table to server.
local config = {
  endpointUrl="opc.tcp://localhost:4841",
}

local uaServer = ua.newServer(config)
uaServer:initialize()

-- Add node to OPCUA server where we will store temperature value
local ObjectsFolder = "i=85"
local resp = uaServer:addNodes({NodesToAdd = {ua.newVariableParams(ObjectsFolder, "ds18b20", {Value={Float=0}})}})
local results = resp.Results
assert(results[1].StatusCode, ua.StatusCode.Good)
local sensorNodeId =  results[1].AddedNodeId

-- Create MQTT publisher
local mqttConfig = {
    bufSize = 1024
  }
local mqttPublisher = ua.newMqttClient(mqttConfig, uaServer)

-- Create dataset with fields in MQTT message,
-- Publisher will start listening of NodeID values changes in OPCUA server.
local mqttFields = {
  { nodeId = sensorNodeId, name = "ds18b20"}
}

local classId = "6fa38ebb-44d2-a3ec-d251-1030c777f10a"
mqttPublisher:createDataset(mqttFields, classId)

-- Connect to MQTT broker
local tranportProfileUri = ua.Types.TranportProfileUri.MqttBinary
local endpointUrl = "opc.mqtt://test.mosquitto.org:1883"
mqttPublisher:connect(endpointUrl, tranportProfileUri)

-- Start publishing data to MQTT broker
local dataTopic = "rtl/json/data/urn:arykovanov-note:opcua:server/group/dataset"
mqttPublisher:startPublishing(dataTopic, "test_cyclic_publisher", 2000)

-- Run server. Start listening to port
uaServer:run()

-- Timer callback function which writes temperature value to node
local function writeTemp(temperature, err)
  trace(temperature, err)
  local secs, ns = ba.datetime("NOW"):ticks()
  secs = secs + ns / 1e9
  local writeRequest = {
    NodesToWrite = {
      {
        NodeId = sensorNodeId,
        AttributeId = ua.Types.AttributeId.Value,
        Value = {
          Value = { Float=temperature },
          ServerTimestamp = secs,
          StatusCode = ua.StatusCode.Good
        },
      }
    }
  }

  local resp, err = uaServer:write(writeRequest)
end

local ds18b20Timer = ba.timer(function()
  -- Read temperature from DS18B20 sensor
  readTemp(GPIO_PIN, writeTemp)
  return true
end)

-- Set timer to 1 second
ds18b20Timer:set(2000)

function onunload()
  ds18b20Timer:cancel()
  mqttPublisher:stopPublishing()
  uaServer:shutdown()
end
