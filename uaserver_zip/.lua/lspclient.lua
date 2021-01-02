local ua = require("opcua.api")

local C={} -- OpcUa Client
C.__index=C
function C:browse(nodeId)
  local browseParams = {
    nodesToBrowse = {
      {
        nodeId = nodeId,
        referenceTypeId = "i=33", -- ua.NodeIds.HierarchicalReferences,
        browseDirection = ua.Types.BrowseDirection.Forward,
        nodeClass = ua.Types.NodeClass.Unspecified,
        resultMask = ua.Types.BrowseResultMask.All,
        includeSubtypes = 1,
      }
    },
  }

  trace("\n\n\n")
  trace("Browse server object:")
  local results = self.services:browse(browseParams, response)

  for k,res in pairs(results) do
    for k,ref in pairs(res.references) do
      ref.nodeId = ref.nodeId
      ref.referenceId = ref.referenceId
      trace("  Reference"..k..":")
      trace("    NodeId: "..ref.nodeId)
      trace("    ReferenceId: "..ref.referenceTypeId)
      trace("    IsForward: "..ref.isForward)
      trace("    BrowseName: ns="..ref.browseName.ns..";name="..ref.browseName.name)
      trace("    NodeClass: "..ref.nodeClass)
    end
  end

  return results
end

function C:read(nodeId)
  print("\n\n\n")
  print("Read current time on server:")

  local attr = ua.Types.AttributeId

  local nodes = {}
  for k,v in pairs(ua.Types.AttributeId) do
    if v > attr.Invalid and v < attr.Max then
      table.insert(nodes, {nodeId = nodeId, attributeId = v})
    end
  end

  local results = self.services:read({nodesToRead=nodes}, response)

  for i,result in ipairs(results) do
    result.attributeId = nodes[i].attributeId
  end

  return results
end

function NewUaClient(services)
  local c = {
    services = services
  }
  setmetatable(c, C)
  return c
end

return {New=NewUaClient}
