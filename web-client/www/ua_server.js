const attributeNames = [
    "NodeId",
    "NodeClass",
    "BrowseName",
    "DisplayName",
    "Description",
    "WriteMask",
    "UserWriteMask",
    "IsAbstract",
    "Symmetric",
    "InverseName",
    "ContainsNoLoops",
    "EventNotifier",
    "Value",
    "DataType",
    "ValueRank",
    "ArrayDimensions",
    "AccessLevel",
    "UserAccessLevel",
    "MinimumSamplingInterval",
    "Historizing",
    "Executable",
    "UserExecutable",
    "DataTypeDefinition",
    "RolePermissions",
    "UserRolePermissions",
    "AccessRestrictions",
    "AccessLevelEx",
]

const GetPolicyNames = {
  "http://opcfoundation.org/UA/SecurityPolicy#Basic128Rsa15": "Basic128Rsa15",
  "http://opcfoundation.org/UA/SecurityPolicy#Basic256": "Basic256",
  "http://opcfoundation.org/UA/SecurityPolicy#None": "None",
  "http://opcfoundation.org/UA/SecurityPolicy#Aes128_Sha256_RsaOaep": "Aes128_Sha256_RsaOaep",
  "http://opcfoundation.org/UA/SecurityPolicy#Aes256_Sha256_RsaPss": "Aes256_Sha256_RsaPss"
}


class UAServer {
  constructor(comp) {
      this.Comp = comp
      this.Requests = []
      this.RequestCounter = 0
      this.Sock = null
      this.SiteURL = null
  }

  reset() {
      this.Sock = null
      this.SiteURL = null
  }

  connect(siteURL) {
      if (this.SiteURL == siteURL)
          return

      let _this = this
      let comp = this.Comp
      try  {
          this.Sock = new WebSocket(siteURL)
          this.Sock.onopen = () => {
              comp.onConnected(_this)
              this.SiteURL = siteURL
          }
          this.Sock.onclose =  () => {
            let th = _this;
            _this.reset()
            comp.onDisconnected(th)
          }
          this.Sock.onmessage =  function(msg) {
              let resp = JSON.parse(msg.data)
              let request = _this.Requests.filter(el => el.id == resp.id)
              if (request.length == 0) {
                  alert("reseived response on unknown request: " + msg.data)
                  return
              }

              request[0].callback(resp)
          }
          this.Sock.onerror = (e) => {
              _this.reset()
              comp.onDisconnected(e)
          }
      }
      catch(e) {
          _this.reset()
          comp.onDisconnected(e)
      }
  }

  disconnect() {
      if (this.Sock != null) {
          this.Sock.close()
          this.reset()
      }
  }

  requestId() {
      this.RequestCounter += 1
      return this.RequestCounter
  }

  sendRequest(request, callback) {
      if (this.Sock == null){
          alert("No connection to web socket server.")
          return;
      }

      request.id =  this.requestId(),
      this.Requests.push({id: request.id, callback: callback})
      try {
          this.Sock.send(JSON.stringify(request))
      }
      catch (e){
          this.Requests.filter(el => {el.requestId == request.id})
          alert("failed to send  request")
      }
  }

  connectEndpoint(config, callback){
      let request = {
          connectEndpoint: config
      }
      this.sendRequest(request, callback)
  }

  getEndpoints(config, callback) {
    let request = {
      getEndpoints: config
    }
    this.sendRequest(request, callback)
  }

  browse(nodeId, callback){
      let request = {
          browse: {
              nodeId: nodeId
          }
      }
      this.sendRequest(request, callback)
  }

  readAttributes(nodeId, callback){
      let request = {
          read: {
              nodeId: nodeId
          }
      }
      this.sendRequest(request, callback)
  }

  getAttributeName(attrId) {
      return attributeNames[attrId]
  }

  getPolicyName(uri) {
    let name = GetPolicyNames[uri]
    if (!name)
      return uri;

    return name;
  }

  getPolicyName(uri) {
    let name = GetPolicyNames[uri]
    if (!name)
      return uri;

    return name;
  }

  getMessageModeName(mode) {
    switch(mode)
    {
      case 1: return "None";
      case 2: return "Sign";
      case 3: return "SignAndEncrypt";
      default: return mode
    }
  }
}

export { UAServer }
