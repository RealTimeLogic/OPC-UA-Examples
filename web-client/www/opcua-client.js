import { createApp } from './vue.esm-browser.js'
import { UAServer } from "./ua_server.js"

var onNodeSelected = () => {}
var uaServer = null

function getWebSocketUrl() {
  // let l = window.location
  // let protocol = l.protocol === 'https:' ? "wss://" : "ws://"
  // let url = protocol + l.host + l.pathname + "opcua_client.lsp"
  const url = "ws://localhost/opcua_client.lsp";
  return url;
}

var root = {
  nodeid: "i=84",
  label: "Root",
  nodes: []
}


var app = createApp({
    data() {
      return {
        root: root,
        webSocketUrl: getWebSocketUrl(),
        endpointUrl: "opc.tcp://localhost:4841",
        connected: false,
        websocketConnected: false,
        endpoints: [],
        selectedEndpointIndex: 0
      }
    },
    mounted() {
      uaServer = new UAServer(this)
      this.connect()
    },
    methods: {
        connect: function() {
            if (!this.connected)
            {
              console.info("Connecting to Websocket " + this.webSocketUrl)
              uaServer.connect(this.webSocketUrl)
            }
            else
            {
              uaServer.disconnect()
            }
        },

        connectEndpoint() {
            var self = this
            this.connected = false;
            let endpoint = this.endpoints[this.selectedEndpointIndex]
            root.nodes = []

            var config = {
              applicationName: 'RealTimeLogic web client',
              applicationUri: "urn:opcua-lua:web_client",
              productUri: "urn:opcua-lua:web_client",

              endpointUrl: this.endpointUrl,
              securityPolicyUri: endpoint.securityPolicyUri,
              securityMode: endpoint.securityMode,
              serverCertificate: endpoint.serverCertificate
            }
            uaServer.connectEndpoint(config, resp => {
                if (resp.error)
                {
                  this.connected = false;
                  return;
                }
                this.connected = true;
                // onNodeSelected("i=84");
            })
        },

        onConnected: function() {
            console.log("Web socket connected");
            this.websocketConnected = true
        },
        onDisconnected: function(e) {
            console.log("Web socket disconnected:" + (e ? e : ""));
            this.websocketConnected = false
        },
        fillSecurePolicies ()
        {
          this.connected = false
          var config = {
            applicationName: 'RealTimeLogic web client',
            applicationUri: "urn:opcua-lua:web_client",
            productUri: "urn:opcua-lua:web_client",

            endpointUrl: this.endpointUrl,
            securityPolicyUri: "http://opcfoundation.org/UA/SecurityPolicy#None",
          }

          let fillEndpointsList = (resp) => {
            if (resp.error)
            {
              alert(resp.error)
              return
            }
      
            let endpoints = resp.endpoints;
            endpoints.forEach((val, idx, arr) => {
              arr[idx].policyName = uaServer.getPolicyName(val.securityPolicyUri);
              arr[idx].securityModeName = uaServer.getMessageModeName(val.securityMode);
              arr[idx].id = arr[idx].policyName + "-" + arr[idx].securityModeName
            })
      
            endpoints.sort((a,b) => {
              if (a.securityLevel != b.securityLevel)
                return b.securityLevel - a.securityLevel;
      
              if (a.securityPolicyUri == b.securityPolicyUri)
                return a.securityMode - b.securityMode;
      
              return a.securityPolicyUri.localeCompare(b.securityPolicyUri)
            })
      
            this.endpoints = endpoints
          }

          uaServer.connectEndpoint(config, (resp) => {
            uaServer.getEndpoints({}, fillEndpointsList);
          })
        }    
    }
})

app.component("ua-attributes", {
    template:
    '\
        <div v-if="visible">\
          <table class="table-node-attributes">\
              <tr v-for="attr in attributes">\
                  <td class="td-node-attribute td-node-attribute-name" >{{attr.name}}</td>\
                  <td class="td-node-attribute td-node-attribute-value" style="text-align: left"><pre>{{attr.value}}</pre></td>\
              </tr>\
          </table>\
        </div>\
    ',
    data() {
        return {
            attributes: [],
        }
    },
    computed: {
        visible() {
            return this.attributes.length != 0
        }
    },
    methods: {
        readAttributes(nodeId) {
            var self = this
            uaServer.readAttributes(nodeId, resp => {
                if (!resp.read)
                {
                    this.attributes = []
                    return;
                }

                let attrs = []
                resp.read.forEach( (attr,index) => {
                    if ((typeof(attr.statusCode) != "undefined" && attr.statusCode != 0) || typeof(attr.value) == "undefined")
                        return

                    attrs.push({
                        name: uaServer.getAttributeName(index),
                        value: JSON.stringify(attr.value, null, "  ")
                    })
                });
                this.attributes = attrs
            })
        },
    },
    mounted() {
      onNodeSelected = (selectedId) => {
        this.readAttributes(selectedId)
      }
    }
})

app.component("ua-node", {
    props:['root'],
    computed: {
    },
    template:
        '<div>\
            <div class="node-row">\
                <div class="node-plus" v-on:click.prevent="browse">{{ root.nodes.length == 0 ? "+" : "-" }}</div> \
                <div class="node-name" v-on:click.prevent="selectNode">{{root.label}}</div> \
            </div>\
            <ua-node class="node-children" v-for="(node,index) in root.nodes" :key="index" :root="node"/>\
        </div>',

    methods: {
        browse: function() {
            if (this.root.nodes.length != 0)
            {
                this.root.nodes = []
                return
            }

            uaServer.browse(this.root.nodeid, (resp) => {
                if (!resp.browse)
                {
                    if(resp.error)
                        alert(resp.error);
                    return;
                }

                let nodes = []
                resp.browse.forEach(result => {
                    result.references.forEach(ref => {
                        nodes.push({
                            nodeid: ref.nodeId,
                            label: ref.browseName.name,
                            nodes: []
                        })
                    })
                });

                this.root.nodes = nodes
            })
        },
        selectNode: function() {
          onNodeSelected(this.root.nodeid);
        }
    }
})

app.mount('#opcua-client-app')
