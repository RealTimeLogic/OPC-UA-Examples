local ua = require("opcua.api")
local nodeIds = {
  RootFolder = "i=84",
  TypesFolder = "i=86",
  HierarchicalReferences = "i=33",
}

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
err = client:connect(endpointUrl)
if err ~= nil then
  return
end

-- Open secure channel with timeout 120 seconds
resp, err = client:openSecureChannel(120000, ua.SecurityPolicy.None, ua.MessageSecurityMode.None)
if err ~= nil then
  return
end

resp, err = client:createSession("test_session", 3600000)
if err ~= nil then
  trace("Create session failed: "..err)
  return
end

resp, err = client:activateSession()
if err ~= nil then
  return
end

-- Browse one node by ID.
resp, err = client:browse(nodeIds.RootFolder)
if err ~= nil then
  return
end

for _,res in ipairs(resp.Results) do
  if res.StatusCode ~= ua.StatusCode.Good then
    trace(string.format("Cannot browse node: 0x%X", res.StatusCode))
  else
    trace("References:")
    for i,ref in ipairs(res.References) do
      trace(string.format("%d: NodeId=%s Name=%s", i, ref.NodeId, ref.DisplayName.Text))
    end
  end
end


-- Browse array of Node IDs.
resp, err = client:browse({nodeIds.RootFolder, nodeIds.TypesFolder})
if err ~= nil then
  return
end

for _,res in ipairs(resp.Results) do
  if res.StatusCode ~= ua.StatusCode.Good then
    trace(string.format("Cannot browse node: 0x%X", res.StatusCode))
  else
    trace("References:")
    for i,ref in ipairs(res.References) do
      trace(string.format("%d: NodeId=%s Name=%s", i, ref.NodeId, ref.DisplayName.Text))
    end
  end
end

-- Full featured browsing
local browseParams = {
  NodesToBrowse = {
    {
      NodeId = nodeIds.RootFolder,
      ReferenceTypeId = nodeIds.HierarchicalReferences,
      BrowseDirection = ua.BrowseDirection.Forward,
      NodeClassMask = ua.NodeClass.Unspecified,
      ResultMask = ua.BrowseResultMask.All,
      IncludeSubtypes = true,
    },
    {
      NodeId = nodeIds.RootFolder,
      ReferenceTypeId = nodeIds.HierarchicalReferences,
      BrowseDirection = ua.BrowseDirection.Forward,
      NodeClassMask = ua.NodeClass.Unspecified,
      ResultMask = ua.BrowseResultMask.All,
      IncludeSubtypes = true,
    }
  },
}

local resp,err = client:browse(browseParams)
for _,res in ipairs(resp.Results) do
  if res.StatusCode ~= ua.StatusCode.Good then
    trace(string.format("Cannot browse node: 0x%X", res.StatusCode))
  else
    trace("References:")
    for i,ref in ipairs(res.References) do
      trace(string.format("%d: NodeId=%s Name=%s", i, ref.NodeId, ref.DisplayName.Text))
    end
  end
end

client:disconnect()
