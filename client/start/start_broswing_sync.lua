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

for _,res in ipairs(resp.results) do
  if res.statusCode ~= ua.StatusCode.Good then
    trace(string.format("Cannot browse node: 0x%X", res.statusCode))
  else
    trace("References:")
    for i,ref in ipairs(res.references) do
      trace(string.format("%d: NodeId=%s Name=%s", i, ref.nodeId, ref.displayName.text))
    end
  end
end


-- Browse array of Node IDs.
resp, err = client:browse({nodeIds.RootFolder, nodeIds.TypesFolder})
if err ~= nil then
  return
end

for _,res in ipairs(resp.results) do
  if res.statusCode ~= ua.StatusCode.Good then
    trace(string.format("Cannot browse node: 0x%X", res.statusCode))
  else
    trace("References:")
    for i,ref in ipairs(res.references) do
      trace(string.format("%d: NodeId=%s Name=%s", i, ref.nodeId, ref.displayName.text))
    end
  end
end

-- Full featured browsing
local browseParams = {
  requestedMaxReferencesPerNode = 0,
  nodesToBrowse = {
    {
      nodeId = nodeIds.RootFolder,
      referenceTypeId = nodeIds.HierarchicalReferences,
      browseDirection = ua.Types.BrowseDirection.Forward,
      nodeClassMask = ua.Types.NodeClass.Unspecified,
      resultMask = ua.Types.BrowseResultMask.All,
      includeSubtypes = 1,
    },
    {
      nodeId = nodeIds.RootFolder,
      referenceTypeId = nodeIds.HierarchicalReferences,
      browseDirection = ua.Types.BrowseDirection.Forward,
      nodeClassMask = ua.Types.NodeClass.Unspecified,
      resultMask = ua.Types.BrowseResultMask.All,
      includeSubtypes = 1,
    }
  },
}

local resp,err = client:browse(browseParams)
for _,res in ipairs(resp.results) do
  if res.statusCode ~= ua.StatusCode.Good then
    trace(string.format("Cannot browse node: 0x%X", res.statusCode))
  else
    trace("References:")
    for i,ref in ipairs(res.references) do
      trace(string.format("%d: NodeId=%s Name=%s", i, ref.nodeId, ref.displayName.text))
    end
  end
end

client:disconnect()
