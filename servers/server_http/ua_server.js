let attributeNames = [
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
                comp.onConnected()
                this.SiteURL = siteURL
            }
            this.Sock.onclose =  () => {
                _this.reset()
                comp.onDisconnected()
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
        return attributeNames[attrId - 1]
    }

}
