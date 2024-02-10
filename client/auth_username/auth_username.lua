local ua = require("opcua.api")
RootFolder = "i=84"

local config = {
  applicationName = 'RealTimeLogic example',
  applicationUri = "urn:opcua-lua:example",
  productUri = "urn:opcua-lua:example",
  securePolicies = {
    { -- #1
      securityPolicyUri = ua.Types.SecurityPolicy.None,
    },
  },
}

local client = ua.newClient(config)

local resp, err

-- Connecting to OPCUA server
trace("connecting to server")
local endpointUrl = "opc.tcp://localhost:4841"
err = client:connect(endpointUrl, ua.Types.TranportProfileUri.TcpBinary)
if err ~= nil then
  return
end

-- Open secure channel with timeout 120 seconds
resp, err = client:openSecureChannel(120000, ua.Types.SecurityPolicy.None, ua.Types.MessageSecurityMode.None)
if err ~= nil then
  return
end

local session, err = client:createSession("test_session", 3600000)
if err ~= nil then
  trace("Create session failed: "..err)
  return
end

local tokenPolicy
for _, endpoint in ipairs(session.serverEndpoints) do
  for _, policy in ipairs(endpoint.userIdentityTokens) do
    if policy.tokenType == ua.Types.UserTokenType.UserName and
      (policy.securityPolicyUri == nil or policy.securityPolicyUri == ua.Types.SecurityPolicy.None)
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
local resp, err = client:activateSession(tokenPolicy.policyId, userName, password)
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
