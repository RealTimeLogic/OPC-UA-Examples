local ua = require("opcua.api")
RootFolder = "i=84"

local config = {
  applicationName = 'RealTimeLogic example',
  applicationUri = "urn:opcua-lua:example",
  productUri = "urn:opcua-lua:example",
  securePolicies = {
    { -- #1
      securityPolicyUri = ua.SecurityPolicy.None,
    },
  },
}

local client = ua.newClient(config)

local resp, err

-- Connecting to OPCUA server
trace("connecting to server")
local endpointUrl = "opc.tcp://localhost:4841"
err = client:connect(endpointUrl, ua.TranportProfileUri.TcpBinary)
if err ~= nil then
  return
end

-- Open secure channel with timeout 120 seconds
resp, err = client:openSecureChannel(120000, ua.SecurityPolicy.None, ua.MessageSecurityMode.None)
if err ~= nil then
  return
end

local session, err = client:createSession("test_session", 3600000)
if err ~= nil then
  trace("Create session failed: "..err)
  return
end

local tokenPolicy
for _, endpoint in ipairs(session.ServerEndpoints) do
  for _, policy in ipairs(endpoint.UserIdentityTokens) do
    if policy.TokenType == ua.UserTokenType.UserName and
      (policy.SecurityPolicyUri == nil or policy.SecurityPolicyUri == ua.SecurityPolicy.None)
    then
      tokenPolicy = policy
      goto found
    end
  end
end

::found::
if not tokenPolicy then
  error("cannot find endpoint with username token.")
end

local userName = "admin"
local password = "12345"
local resp, err = client:activateSession(tokenPolicy.PolicyId, userName, password)
if err ~= nil then
  return
end

-- Browse one node by ID.
resp, err = client:browse(RootFolder)
if err ~= nil then
  return
end

client:closeSession()
client:closeSecureChannel()
client:disconnect()
