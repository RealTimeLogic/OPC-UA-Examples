local familyCodes <const> = {
  [0x01] = "DS1990A, DS1990R, DS2401, DS2411 - Serial number",
  [0x02] = "DS1991 1152b - Secure memory",
  [0x04] = "DS2404 - EconoRAM time chip",
  [0x05] = "DS2405 - Addressable switch",
  [0x06] = "DS1993 - 4Kb Memory button",
  [0x08] = "DS1992 - 1kb memory button",
  [0x0A] = "DS1995 - 16kb memory button",
  [0x0B] = "DS1985, - DS2505	16kb add-only memory",
  [0x0C] = "DS1996 - 64kb memory button",
  [0x0F] = "DS1986, DS2506 - 64kb add-only memory",
  [0x10] = "DS18S20 - temperature sensor",
  [0x12] = "DS2406, DS2407 - dual addressable switch",
  [0x14] = "DS1971, DS2430A - 256b EEPROM",
  [0x16] = "DS1954, DS1957 - coprocessor ibutton",
  [0x18] = "DS1962, DS1963S - 4kb monetary device with SHA",
  [0x1A] = "DS1963L - 4kb monetary device",
  [0x1B] = "DS2436 - battery ID/monitor",
  [0x1C] = "DS28E04-100 - 4kb EEPROM with PIO",
  [0x1D] = "DS2423 - 4kb 1Wire RAM with counter",
  [0x1E] = "DS2437 - smart battery monitor IC",
  [0x1F] = "DS2409 - microlan coupler",
  [0x20] = "DS2450 - quad ADC",
  [0x21] = "DS1921G, DS1921H, DS1921Z - thermochron loggers",
  [0x22] = "DS1822 - econo digital thermometer",
  [0x23] = "DS1973, DS2433 - 4kb EEPROM",
  [0x24] = "DS2415 - time chip",
  [0x26] = "DS2438 - smart battery monitor",
  [0x27] = "DS2417 - time chp",
  [0x28] = "DS18B20 - temperature sensor",
  [0x29] = "DS2408 - 8-channel switch",
  [0x2C] = "DS2890 - digital potentiometer",
  [0x2D] = "DS1972, DS2431 - 1024b memory",
  [0x2E] = "DS2770 - battery monitor/charge controller",
  [0x30] = "DS2760 - precision li+ battery monitor",
  [0x31] = "DS2720 - single cell li+ protection IC",
  [0x32] = "DS2780 - fuel gauge IC",
  [0x33] = "DS1961S, DS2432 - 1kb memory with SHA",
  [0x34] = "DS2703 - sha battery authentication",
  [0x35] = "DS2755 - fuel gauge",
  [0x36] = "DS2740 - coulomb counter",
  [0x37] = "DS1977 - 32kb memory",
  [0x3D] = "DS2781 - fuel gauge IC",
  [0x3A] = "DS2413 - two-channel switch",
  [0x3B] = "DS1825, MAX31826, MAX31850 - temperature sensor, TC reader",
  [0x41] = "DS1923, DS1922E, DS1922L, DS1922T - hygrochrons",
  [0xF0] = "MOAT - custom microcontroller slave",
  [0x42] = "DS28EA00 - digital thermometer with sequence detect",
  [0x43] = "DS28EC20 - 20kb memory",
  [0x44] = "DS28E10 - sha1 authenticator",
  [0x51] = "DS2751 - battery fuel gauge",
  [0x7E] = "EDS00xx - EDS sensor adapter",
  [0x81] = "USBID, DS1420 - ID",
  [0x82] = "DS1425 - ID and pw protected RAM",
  [0xA0] = "mRS001",
  [0xA1] = "mVM0011",
  [0xA2] = "mCM001",
  [0xA6] = "mTS017",
  [0xB1] = "mTC001",
  [0xB2] = "mAM001",
  [0xB3] = "mTC002",
  [0xEE] = "mTC002",
  [0xEF] = "Moisture Hub",
  [0xFC] = "BAE0910, BAE0911",
  [0xFF] = "Swart LCD"
}

local tInsert=table.insert
local cResume,cYield=coroutine.resume,coroutine.yield

local rst <const> = { {0,480,1,70} }
local releaseHw <const> = { {1,1,1,0} }
local eot <const> = {eot=1}
local rxCfg <const> = {min=2000,max=70*1000}
local rstCfg <const> = {min=2000,max=480*2*1000} -- min/max in ns
local zero <const> = {0,60,1,2} -- binary 0
local one <const> = {0,6,1,56} -- binary 1

local function decode(symbols)
  local mask,byte,t=1,0,{}
  for i,sym in ipairs(symbols) do
    -- sym[2] is the duration low level
    if sym[2] <= 15 then byte = byte | mask end
    mask = mask << 1
    if 256 == mask then
      tInsert(t,byte & 0xFF)
      mask,byte = 1,0
    end
  end
  return t
end

local bus = {}
bus.__index = bus

local function receive(rx, cfg)
  local suc, err = pcall(rx.receive, rx, cfg)
  if not suc then
    error(err)
  end
end

function bus:reset()
  receive(self.rx, rstCfg)
  self.tx:transmit(eot, rst)
  local symbols = cYield()
  local res = symbols ~= nil and #symbols == 2
  return res
end

function bus:sendBytes(bytes, sz)
  receive(self.rx, rxCfg)
  self.tx:transmit(eot, {{false, zero, one, bytes}})
  if sz then
    return self:readBytes(sz)
  end
  return cYield()
end

function bus:readBytes(sz)
  local t={}
  for i=1,sz do tInsert(t,0xFF) end
  return decode(self:sendBytes(t))
end

function bus:sendBit(val)
  local bit = (val == 0 or val == false) and zero or one
  receive(self.rx, rxCfg)
  self.tx:transmit(eot, { bit })
  return cYield()
end

function bus:readBit()
  local sym = self:sendBit(1)
  local data = sym[1][2] <= 15 and 1 or 0
  return data
end

function bus:cmd(cmd, sz)
  if self:reset(rx, tx) == false then
    return nil, "No device connected"
  end
  self:sendBytes(cmd)
  local data
  if sz and sz > 0 then
    data = decode(self:readBytes(sz))
  end
  return data
end

function bus:matchRom(rom)
  self:reset()
  if rom then
    self:sendBytes({0x55})
    self:sendBytes(rom)
  else
    self:sendBytes({0xCC})
  end
end

local dscrc_table = {
  0, 94, 188, 226, 97, 63, 221, 131, 194, 156, 126, 32, 163, 253, 31, 65,
  157, 195, 33, 127, 252, 162, 64, 30, 95, 1, 227, 189, 62, 96, 130, 220,
  35, 125, 159, 193, 66, 28, 254, 160, 225, 191, 93, 3, 128, 222, 60, 98,
  190, 224, 2, 92, 223, 129, 99, 61, 124, 34, 192, 158, 29, 67, 161, 255,
  70, 24, 250, 164, 39, 121, 155, 197, 132, 218, 56, 102, 229, 187, 89, 7,
  219, 133, 103, 57, 186, 228, 6, 88, 25, 71, 165, 251, 120, 38, 196, 154,
  101, 59, 217, 135, 4, 90, 184, 230, 167, 249, 27, 69, 198, 152, 122, 36,
  248, 166, 68, 26, 153, 199, 37, 123, 58, 100, 134, 216, 91, 5, 231, 185,
  140, 210, 48, 110, 237, 179, 81, 15, 78, 16, 242, 172, 47, 113, 147, 205,
  17, 79, 173, 243, 112, 46, 204, 146, 211, 141, 111, 49, 178, 236, 14, 80,
  175, 241, 19, 77, 206, 144, 114, 44, 109, 51, 209, 143, 12, 82, 176, 238,
  50, 108, 142, 208, 83, 13, 239, 177, 240, 174, 76, 18, 145, 207, 45, 115,
  202, 148, 118, 40, 171, 245, 23, 73, 8, 86, 180, 234, 105, 55, 213, 139,
  87, 9, 235, 181, 54, 104, 138, 212, 149, 203, 41, 119, 244, 170, 72, 22,
  233, 183, 85, 11, 136, 214, 52, 106, 43, 117, 151, 201, 74, 20, 246, 168,
  116, 42, 200, 150, 21, 75, 169, 247, 182, 232, 10, 84, 215, 137, 107, 53
}

local function docrc8(crc8, value)
  -- Calculate the CRC8 of the byte value provided with the current global 'crc8' value.
  local crc = dscrc_table[((crc8 ~ value) & 0xFF) + 1]
  return crc
end

function bus:crc8(data, len)
  len = len or #data
  local crc = 0
  for i=1,len-1 do
    crc = docrc8(crc, data[i])
  end
  return crc
end

-- Adopted C code from: https://www.analog.com/en/resources/app-notes/1wire-search-algorithm.html
function bus:search(isNext)
   -- Platform specific functions
   local function OWReset()
      return self:reset() and 1 or 0
   end
   local function OWWriteByte(byte_value)
      return self:sendBytes({byte_value})
   end
   local function OWWriteBit(bit_value)
      self:sendBit(bit_value)
   end
   local function OWReadBit()
      return self:readBit()
   end

  -- definitions
  local FALSE <const> = 0
  local TRUE <const> = 1
  -- global search state
  local ROM_NO = {0,0,0,0,0,0,0,0}
  local LastDiscrepancy = 0
  local LastFamilyDiscrepancy = 0
  local LastDeviceFlag = FALSE

  local function OWSearch()
    local id_bit_number = 1
    local last_zero = 0
    local rom_byte_number = 0
    local rom_byte_mask = 1
    local search_result = FALSE
    local id_bit = 0
    local cmp_id_bit = 0
    local search_direction = FALSE
    local crc8 = 0

      -- if the last call was not the last one
    if LastDeviceFlag == FALSE then
      -- 1-Wire reset
      if OWReset() == FALSE then
        -- reset the search
        LastDiscrepancy = 0
        LastDeviceFlag = FALSE
        LastFamilyDiscrepancy = 0
        return FALSE
      end

      -- issue the search command
      local resp = OWWriteByte(0xF0)
      -- loop to do the search
      repeat
        id_bit = OWReadBit()
        cmp_id_bit = OWReadBit()

        -- check for no devices on 1-wire
        if id_bit == 1 and cmp_id_bit == 1 then
          break
        else
          -- all devices coupled have 0 or 1
          if id_bit ~= cmp_id_bit then
            search_direction = id_bit -- bit write value for search
          else
            -- if this discrepancy is before the Last Discrepancy on a previous next, then pick the same as last time
            if id_bit_number < LastDiscrepancy then
              search_direction = (ROM_NO[rom_byte_number + 1] & rom_byte_mask) > 0
            else
              -- if equal to last, pick 1, if not, then pick 0
              search_direction = (id_bit_number == LastDiscrepancy) and TRUE or FALSE
            end

            -- if 0 was picked, then record its position in LastZero
            if search_direction == FALSE then
              last_zero = id_bit_number
              -- check for Last discrepancy in family
              if last_zero < 9 then
                  LastFamilyDiscrepancy = last_zero
              end
            end
          end

          -- set or clear the bit in the ROM byte rom_byte_number with mask rom_byte_mask
          if search_direction == TRUE then
            ROM_NO[rom_byte_number + 1] = ROM_NO[rom_byte_number + 1] | (rom_byte_mask & 0xFF)
          else
            ROM_NO[rom_byte_number + 1] = ROM_NO[rom_byte_number + 1] & ((~rom_byte_mask) & 0xFF)
          end
          -- serial number search direction write bit
          OWWriteBit(search_direction)

          -- increment the byte counter id_bit_number and shift the mask rom_byte_mask
          id_bit_number = id_bit_number + 1
          rom_byte_mask = (rom_byte_mask << 1) & 0xFF
          -- if the mask is 0, then go to new SerialNum byte rom_byte_number and reset mask
          if rom_byte_mask == 0 then
            crc8 = docrc8(crc8, ROM_NO[rom_byte_number + 1]) -- accumulate the CRC
            rom_byte_number = rom_byte_number + 1
            rom_byte_mask = 1
          end
        end
      until rom_byte_number >= 8 -- loop until through all ROM bytes 0-7
      -- if the search was successful then
      if not (id_bit_number < 65 or crc8 ~= 0) then
        -- search successful, so set LastDiscrepancy, LastDeviceFlag, search_result
        LastDiscrepancy = last_zero

        -- check for last device
        if LastDiscrepancy == 0 then
          LastDeviceFlag = TRUE
        end

        search_result = TRUE
      end
    end

    -- if no device found, then reset counters so next 'search' will be like a first
    if search_result == FALSE or ROM_NO[1] == 0 then
      LastDiscrepancy = 0
      LastDeviceFlag = FALSE
      LastFamilyDiscrepancy = 0
      search_result = FALSE
      return
    end

    local result = {}
    for _, rom in ipairs(ROM_NO) do
      tInsert(result, rom)
    end

    return result
  end

  -- function declarations
  local function OWFirst(isFirst)
    -- reset the search state
    LastDiscrepancy = 0
    LastDeviceFlag = FALSE
    LastFamilyDiscrepancy = 0
    return OWSearch()
  end

  local function OWNext()
    -- leave the search state alone
    return OWSearch()
  end

  local function iterate(state, last)
    local result
    if last then
      result = OWNext()
    else
      result = OWFirst()
    end
    return result
  end

  return iterate
end

function bus:close()
  self.rx:close()
  self.tx:close()
  self.coro = nil
end

function bus.__close(self)
  self:close()
end

return function(gpio, co)
  local t = {
    coro = co
  }

  local rx = esp32.rmtrx({gpio=gpio,resolution=1000000,callback = function(data)
    cResume(t.coro, data)
  end})
  local tx = esp32.rmttx({gpio=gpio, resolution=1000000, opendrain=false},rx)

  t.rx = rx
  t.tx = tx

  tx:enable()
  tx:transmit(eot, releaseHw) -- make line high

  setmetatable(t, bus)
  return t
end
