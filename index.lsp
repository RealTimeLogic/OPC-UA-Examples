<?lsp

local ua = require("opcua.api")
local localServer = io:dofile("local_server.lua")

local examples_root = mako.getapps()[1]
local servers = {
  {path=examples_root.."/client/auth_username", isLocal=true},
  {path=examples_root.."/client/auth_x509", isLocal=true},
  {path=examples_root.."/client/start", isLocal=true},
  {path=examples_root.."/servers/write_data"},
  {path=examples_root.."/servers/server_http"},
  {path=examples_root.."/servers/server_config"},
  {path=examples_root.."/servers/server_basic128rsa15"},
  {path=examples_root.."/servers/read_data"},
  {path=examples_root.."/servers/embed_web_server"},
  {path=examples_root.."/servers/data_source"},
  {path=examples_root.."/servers/add_nodes"},
  {path=examples_root.."/servers/start"},
  {path=examples_root.."/servers/server_config"},
  {path=examples_root.."/servers/browse"},
}

local function FailIfError(err)
  if type(err) == 'string' then
    trace("--------------------------------------------------------")
    trace("--------------- !!!!!! FAIL !!!!!!-----------------------")
    trace("--------------------------------------------------------")

    trace("Error: " .. tostring(err))
    os.exit(-1)
  end
end

for i, server in ipairs(servers) do
  trace("--------------------------------------------------------")
  local appName = "server_"..i
  trace(string.format("loading app %s: '%s'", appName, server.path))

  if server.isLocal then
    local result, err = localServer.start()
    FailIfError(err)
    err = nil
  end

  local result, err = mako.createapp(appName, 0, server.path)
  FailIfError(err)
  err = nil

  trace("stopping app '" .. appName.."'")
  local result, err = mako.stopapp(2)
  trace("stopping app '" .. appName.."'")
  local result, err = mako.removeapp(2)

  if server.isLocal then
    local result, err = localServer.stop()
    FailIfError(err)
    err = nil
  end

  trace("--------------------------------------------------------")
end




trace("--------------------------------------------------------")
trace("---------------    SUCCESS       -----------------------")
trace("--------------------------------------------------------")


os.exit(0)

?>
