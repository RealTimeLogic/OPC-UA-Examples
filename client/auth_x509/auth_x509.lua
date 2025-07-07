local ua = require("opcua.api")
-- local nodeIds = require("opcua.node_ids")

local config = {
  io = io,
  applicationName = 'RealTimeLogic example',
  applicationUri = "urn:opcua-lua:example",
  productUri = "urn:opcua-lua:example",
  securePolicies = {
    { -- #1
      securityPolicyUri = ua.SecurityPolicy.None,
    },
    { -- #2
      securityPolicyUri = ua.SecurityPolicy.Basic128Rsa15,
      securityMode = ua.MessageSecurityMode.SignAndEncrypt,
      certificate = "./basic128rsa15_client.pem",
      key =         "./basic128rsa15_client.key",
    }
  },
}

local client = ua.newClient(config)

local resp, err

-- Connecting to OPCUA server
trace("connecting to server")
local endpointUrl = "opc.tcp://localhost:4841"
err = client:connect(endpointUrl)
if err ~= nil then
  return
end

-- Open secure channel with timeout 120 seconds
resp, err = client:openSecureChannel(120000, ua.SecurityPolicy.None, ua.MessageSecurityMode.None)
if err ~= nil then
  return
end

local session, err = client:createSession("test_session", 3600000)
local tokenPolicy
for _, endpoint in ipairs(session.ServerEndpoints) do
  -- Select certificate token policy with security policy Basic128Rsa15
  for _, policy in ipairs(endpoint.UserIdentityTokens) do
    if  policy.TokenType == ua.UserTokenType.Certificate then
      tokenPolicy = policy
      goto found
    end
  end
end

::found::
if not tokenPolicy then
  error("cannot find endpoint with certificate token policy.")
end

local certificate = "./admin_cert.pem"
local privateKey = "./admin_key.pem"
local resp, err = client:activateSession(
  tokenPolicy.PolicyId, certificate, privateKey)

  if err ~= nil then
  return
end

-- Browse one node by ID.
RootFolder = "i=85"
resp, err = client:browse(RootFolder)
if err ~= nil then
  return
end

client:closeSession()
client:closeSecureChannel()
client:disconnect()
