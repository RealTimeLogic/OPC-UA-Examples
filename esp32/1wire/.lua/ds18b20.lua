local sensor = {}
sensor.__index = sensor

function sensor:convertTemp(rom)
  local bus = self.bus
  bus:matchRom(rom)
  bus:sendBytes({0x44})
end

function sensor:readTemp(rom)
  local bus = self.bus
  bus:matchRom(rom)
  bus:sendBytes({0xBE})
  local len = 9
  local data = bus:readBytes(len)
  bus:reset()

  local crc = bus:crc8(data, len)
  local lsb = data[1]
  local msb = data[2]
  local sign = (msb & 0x80) ~= 0
  local resolution = (data[5] & 0x60) >> 5 -- 6,7 bit
  if resolution == 0 then -- 9bit
    lsb = lsb & 0xF8
  elseif resolution == 1 then -- 10bit
    lsb = lsb & 0xFC
  elseif resolution == 2 then -- 11bit
    lsb = lsb & 0xFE
  end

  local temp = lsb + (msb << 8)
  if sign then
    temp = temp - 65536
  end
  temp = temp / 16
  return temp, data, crc
end

function sensor:close()
  self.bus:close()
end

function sensor:__close()
  self:close()
end

local function create(bus, co)
  if type(bus) == "number" then
    trace("Creating bus on GPIO ", bus)
    bus = require("1wire")(bus, co)
  end
  return setmetatable({bus=bus}, sensor)
end

return create
