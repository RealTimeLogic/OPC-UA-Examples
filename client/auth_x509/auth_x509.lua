local ua = require("opcua.api")
local nodeIds = require("opcua.node_ids")

local config = {
  applicationName = 'RealTimeLogic example',
  applicationUri = "urn:opcua-lua:example",
  productUri = "urn:opcua-lua:example",
  securePolicies = {
    { -- #1
      securityPolicyUri = ua.Types.SecurityPolicy.None,
    },
    { -- #2
      securityPolicyUri = ua.Types.SecurityPolicy.Basic128Rsa15,
      securityMode = ua.Types.MessageSecurityMode.SignAndEncrypt,
      certificate = "./auth_x509/basic128rsa15_client.pem",
      key =         "./auth_x509/basic128rsa15_client.key",
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
resp, err = client:openSecureChannel(120000, ua.Types.SecurityPolicy.None, ua.Types.MessageSecurityMode.None)
if err ~= nil then
  return
end

local session, err = client:createSession("test_session", 3600000)
local tokenPolicy
for _, endpoint in ipairs(session.serverEndpoints) do
  -- Select certificate token policy with security policy Basic128Rsa15
  for _, policy in ipairs(endpoint.userIdentityTokens) do
    if  policy.tokenType == ua.Types.UserTokenType.Certificate then
      tokenPolicy = policy
      goto found
    end
  end
end

::found::
if not tokenPolicy then
  error("cannot find endpoint with certificate token policy.")
end

local certificate = "./auth_x509/admin_cert.pem"
local privateKey = "./auth_x509/admin_key.pem"
local resp, err = client:activateSession(
  tokenPolicy.policyId, certificate, privateKey)

  if err ~= nil then
  return
end

-- Browse one node by ID.
resp, err = client:browse(nodeIds.RootFolder)
if err ~= nil then
  return
end

client:closeSession()
client:closeSecureChannel()
client:disconnect()
