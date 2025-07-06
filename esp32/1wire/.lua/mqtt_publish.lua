--[[

This application shows how to create application that reads
temperature from DS18B20 sensor and publishes it to MQTT broker.
In this example OPCUA server is not used. Data are published
directly to MQTT broker.

]]

local ua = require("opcua.api")
local ds18b20Net = require("ds18b20")

local GPIO_PIN <const> = 4 -- GPIO pin where DS18B20 sensor is connected
local classId <const> = "6fa38ebb-44d2-a3ec-d251-1030c777f10a"
local dataTopic <const> = "rtl/json/data/urn:arykovanov-note:opcua:server/group/dataset"
local publisherId <const> = "test_manual_publisher"
local endpointUrl <const> = "opc.mqtt://test.mosquitto.org:1883"
local tranportProfileUri = ua.TranportProfileUri.MqttJson

local mqttConfig <const> = {
  bufSize = 8192
}

local function searchDS18B20(onewire)
  local roms = {}
  trace(string.format("searchDS18B20 on %s", onewire))
  local cnt = 0
  for rom in onewire:search() do
    local str = table.concat(rom)
    trace("Found rom", str)
    roms[str] = rom
    cnt = cnt + 1
  end

  trace(string.format("Found #%s roms", cnt))

  return roms
end

local roms
local mqttPublisher
local datasetId
local ds18b20

local function publishTemp(co)
  trace("Creating ds18b20Net", ds18b20Net)
  local sensors <close> = ds18b20Net(GPIO_PIN, co)
  trace("roms", roms)
  if not roms then
    trace("Searing roms")

    roms = searchDS18B20(sensors.bus)
    trace("Search finished")

    -- Create MQTT publisher
    trace("Creating MQTT publisher", ua.newMqttClient)
    suc, mqttPublisher = pcall(ua.newMqttClient, mqttConfig)
    if not suc then
      trace("ERROR:", mqttPublisher)
      return
    end

    trace("Set MQTT fields")
    -- Create dataset with fields in MQTT message,
    -- Publisher will start listening of NodeID values changes in OPCUA server.
    local mqttFields = {}
    for romName, _ in pairs(roms) do
      local field = {
        name = romName,
      }
      table.insert(mqttFields, field)
    end

    trace("Creating OPCUA PUBSUB dataset")
    datasetId = mqttPublisher:createDataset(mqttFields)

    trace("Connecting to ", endpointUrl)
    -- Connect to MQTT broker
    mqttPublisher:connect(endpointUrl, tranportProfileUri)
    trace("MQTT ready")
  end

  trace("Measure temp")
  sensors:convertTemp()
  ba.sleep(900)

  trace(string.format("Reading temperatures.."))

  for romName, rom in pairs(roms) do
    trace(string.format("Reading rom %s", romName))
    local temperature = sensors:readTemp(rom)
    trace("Temperature: ", temperature)
    trace(temperature, err)
    local secs, ns = ba.datetime("NOW"):ticks()
    secs = secs + ns / 1e9
    local value = {
      Value = {
        Type = ua.VariantType.Float,
        Value = temperature
      },
      ServerTimestamp = secs,
      StatusCode = ua.StatusCode.Good
    }

    trace("set field value")
    mqttPublisher:setValue(datasetId, romName, value)
  end

  trace("Publish values")
  mqttPublisher:publish(dataTopic, publisherId)
  trace("done")
end

local busy = 0
local function readTemp()
  busy = busy + 1
  if busy > 1 then
    busy = busy - 1
    return true
  end

  trace("mqtt_publish")
  if co then
    trace("coroutine already created")
    return
  end

  trace("creating coroutine")
  local co = coroutine.create(function(co)
    local suc, err = pcall(publishTemp,co)
    trace("Publish Temp:", suc, err)
    busy = busy - 1
  end)

  trace("Starting publish coroutine")
  coroutine.resume(co, co)
  return true
end

local timer

local function start()
  if timer then
    return
  end

  trace("starting publishing timer")
  timer = ba.timer(readTemp)
  timer:set(3000, true, true)
end

local function stop()
  if not timer then
    return
  end

  trace("stopping publishing")
  timer:cancel()
end

return {
  start = start,
  stop = stop
}
