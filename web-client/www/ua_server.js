"use strict";

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
  "http://opcfoundation.org/UA/SecurityPolicy#Basic256Sha256": "Basic256Sha256",
  "http://opcfoundation.org/UA/SecurityPolicy#None": "None",
  "http://opcfoundation.org/UA/SecurityPolicy#Aes128_Sha256_RsaOaep": "Aes128_Sha256_RsaOaep",
  "http://opcfoundation.org/UA/SecurityPolicy#Aes256_Sha256_RsaPss": "Aes256_Sha256_RsaPss"
}


class UAServer {
  constructor(siteURL) {
    this.Requests = new Map() // List of currently issued requests with its parameters
    this.RequestCounter = 0 // Request ID counter

    return new Promise((resolve, reject) => {
      this.Sock = new WebSocket(siteURL);
      this.Sock.onopen = () => {
        console.log("Connected to websocket " + siteURL);
        resolve(this)
      }

      let reset = (e) => {
        for (const request of this.Requests.entries()) {
          let val = request[1]
          val.reject(e);
        }
        this.Sock = null
        this.SiteURL = null
        this.Requests = new Map()
      }

      this.Sock.onclose = () => {
        console.log("Disconnected websocket " + siteURL);
        reset();
        reject()
      }

      this.Sock.onerror = (e) => {
        console.log("Websocket " + siteURL + "error: " + e);
        reset();
        reject(e)
      }

      this.Sock.onmessage =  (msg) => {
        let resp
        resp = JSON.parse(msg.data)

        let request = this.Requests.get(resp.id);
        if (resp.error) {
            request.reject(new Error(resp.error));
        }
        else {
            clearTimeout(request.timeout)
            this.Requests.delete(resp.id)
            request.resolve(resp.data);
        }
      }
    })
  }

  disconnect() {
    return new Promise ((resolve, reject) => {
      if (this.Sock != null) {
        this.Sock.close()
        resolve();
      } else {
        reject()
      }
    })
  }

  nextRequestId() {
      this.RequestCounter += 1
      return this.RequestCounter
  }

  sendRequest(request) {
    return new Promise((resolve, reject) => {
      if (this.Sock == null){
        reject(new Error("No connection to web socket server."))
        return;
      }

      let requestId = this.nextRequestId()
      let requestData = {
        resolve: resolve,
        reject: reject,
        timeout: setTimeout(() => {reject("timeout")}, 5000)
      }

      this.Requests.set(requestId, requestData)

      request.id = requestId
      this.Sock.send(JSON.stringify(request))
    });
  }

  connectEndpoint(endpoint){
    let config
    if (typeof(endpoint) == 'string') {
      config = {
        endpointUrl: endpoint
      }
    } else {
      config = endpoint
    }

    let request = {
        connectEndpoint: config
    }

    return this.sendRequest(request)
  }

  openSecureChannel(timeoutMs, securityPolicyUri, securityMode, serverCertificate) {
    let request = {
      openSecureChannel: {
        timeoutMs: timeoutMs,
        securityPolicyUri: securityPolicyUri,
        securityMode: securityMode,
        serverCertificate: serverCertificate
      }
    }
    return this.sendRequest(request)
  }

  closeSecureChannel() {
    let request = {
      closeSecureChannel: {}
    }
    return this.sendRequest(request)
  }


  createSession(sessionName, timeoutMs) {
    let request = {
      createSession: {
        sessionName: sessionName,
        sessionTimeout: timeoutMs
      }
    }
    return this.sendRequest(request)
  }

  activateSession() {
    let request = {
      activateSession: {}
    }
    return this.sendRequest(request)
  }

  closeSession() {
    let request = {
      closeSession: {}
    }
    return this.sendRequest(request)
  }

  getEndpoints() {
    let request = {
      getEndpoints: {}
    }
    return this.sendRequest(request)
  }

  browse(nodeId) {
    let request = {
        browse: {
            nodeId: nodeId
        }
    }
    return this.sendRequest(request)
  }

  read(nodeId){
    let request = {
        read: {
            nodeId: nodeId
        }
    }
    return this.sendRequest(request)
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
