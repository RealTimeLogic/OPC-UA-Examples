local ua = require("opcua.api")
--[[
local BaSocket={} -- OpcUa Client
BaSocket.__index=BaSocket
function BaSocket:send(data)
  return self.sock:write(data)
end
function BaSocket:receive()
  return self.sock:read()
end

local function NewBaSocket(basock)
  local s = {sock = basock}
  setmetatable(s, BaSocket)
  return s
end
]]
local C={} -- OpcUa Client
C.__index=C
--[[
function C:Connect(endpointUrl)
  trace("conecting to endpoint: "..endpointUrl)

  local url = ua.ParseUrl(endpointUrl)
  if url.Protocol ~= "opc.tcp" then
    error("Unknown scheme")
  end

  trace("conecting to host '"..url.Host.."' port '"..url.Port.."'")
  local sock, err = ba.socket.connect(url.Host, url.Port)
  if err ~= nil then
    trace("error "..err)
    return err
  end
  trace("connected")

  local c = ua.NewBinaryClient(NewBaSocket(sock))
  trace("\n\n\n")
  trace("Saying hello to server")
  local code = c:HelloServer(endpointUrl)
  if code ~= ua.Status.Good then return code end

  trace("Acknowledge: ")
  trace("  ProtocolVersion: '"..c.response.ProtocolVersion.."'")
  trace("  ReceiveBufferSize: '"..c.response.ReceiveBufferSize.."'")
  trace("  SendBufferSize: '"..c.response.SendBufferSize.."'")
  trace("  MaxMessageSize: '"..c.response.MaxMessageSize.."'")
  trace("  MaxChunkCount: '"..c.response.MaxChunkCount.."'")

  print("\n\n\n")
  print("Opening secure channel:")

  local securityParams = {
    SecurityPolicy = ua.SecurityPolicy.None,
    Certificate = nil,
    CertificateThumbprint = nil,

    ClientProtocolVersion = 0,
    RequestType = ua.Types.SecurityTokenRequestType.Issue,
    SecurityMode = ua.Types.MessageSecurityMode.None,
    ClientNonce = "",
    RequestedLifetime = 3600000
  }

  code = c:OpenSecureChannel(securityParams)
  if code ~= ua.Status.Good then return code end
  local secureChannel = c.response
  trace("OpenSecureChannelResponse:")
  trace("  ResponseHeader:")
  trace("    Timestamp: "..secureChannel.ResponseHeader.Timestamp)
  trace("    RequestHandle: "..secureChannel.ResponseHeader.RequestHandle)
  trace("    ServiceResult: "..secureChannel.ResponseHeader.ServiceResult)
  trace("  ServerProtocolVersion = "..secureChannel.ServerProtocolVersion)
  trace("  SecurityToken:")
  trace("    ChannelId = "..secureChannel.SecurityToken.ChannelId)
  trace("    TokenId = "..secureChannel.SecurityToken.TokenId)
  trace("    CreatedAt = "..secureChannel.SecurityToken.CreatedAt)
  trace("    RevisedLifetime = "..secureChannel.SecurityToken.RevisedLifetime)

  local sessionParams = {
    ApplicationName = "opcua web client",
    ApplicationType = ua.Types.ApplicationType.Client,
    ApplicationUri = "urn:opcua-lua:web_client",
    ProductUri = "urn:opcua-lua:web_client",
    SessionName = "web session",
    EndpointUrl = endpointUrl,
    ServerUri = nil,
    SessionTimeout = 3600000,
    ClientCertificate = nil,
    ClientNonce = {1},
  }

  print("\n\n\n")
  print("Creating session:")
  code = c:CreateSession(sessionParams)
  if code ~= ua.Status.Good then return code end

  local response = c.response
  print("  SessionId: ")
  print("    NamespaceIndex: "..response.SessionId.ns)
  print("    Identifier: "..response.SessionId.i)
  print("  MaxRequestMessageSize: "..response.MaxRequestMessageSize)
  print("  AuthenticationToken: ")
  print("    NamespaceIndex: "..response.AuthenticationToken.ns)
  print("    Identifier: "..response.AuthenticationToken.i)
  print("  RevisedSessionTimeout: "..response.RevisedSessionTimeout)

  local SessionId = response.SessionId
  c.SessionAuthToken = response.AuthenticationToken
  print("\n\n\n")
  print("Activating session:")

  local activateParams = {
    ClientSignature = {
      Algorithm = {},
      Signature = {}
    },
    ClientSoftwareCertificates = {},
    Locales = {"en"},
    UserIdentityToken = "\9\0\0\0Anonymous"
  }

  code = c:ActivateSession(activateParams)

  if code ~= ua.Status.Good then return code end
  self.c = c
  print("\n\n\n")
  print("Successfully connected.")
  return ua.Status.Good
end
]]

function C:browse(nodeId)
  local browseParams = {
    nodesToBrowse = {
      {
        nodeId = nodeId,
        referenceTypeId = ua.NodeId.fromString(ua.NodeIds.HierarchicalReferences),
        browseDirection = ua.Types.BrowseDirection.Forward,
        nodeClass = ua.Types.NodeClass.Unspecified,
        resultMask = ua.Types.BrowseResultMask.All,
        includeSubtypes = 1,
      }
    },
  }

  trace("\n\n\n")
  trace("Browse server object:")
  local response = {}
  local code = self.services:browse(browseParams, response)
  if code ~= ua.Status.Good then return code end

  for k,res in pairs(response.results) do
    for k,ref in pairs(res.references) do
      ref.nodeId = ua.NodeId.toString(ref.nodeId)
      ref.referenceId = ua.NodeId.toString(ref.referenceId)
      trace("  Reference"..k..":")
      trace("    NodeId: "..ref.nodeId)
      trace("    ReferenceId: "..ref.referenceId)
      trace("    IsForward: "..ref.isForward)
      trace("    BrowseName: ns="..ref.browseName.nsi..";name="..ref.browseName.name)
      trace("    NodeClass: "..ref.nodeClass)
    end
  end

  return ua.Status.Good,response
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

  local response = {}
  local code = self.services:read({nodesToRead=nodes}, response)
  if code ~= ua.Status.Good then error("OPCUA error:"..code) end

  for i,result in ipairs(response.results) do
    result.attributeId = nodes[i].attributeId
  end

  return ua.Status.Good, response
end

function NewUaClient(services)
  local c = {
    services = services
  }
  setmetatable(c, C)
  return c
end

return {New=NewUaClient}
