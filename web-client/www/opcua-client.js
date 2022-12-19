import { createApp, toHandlers } from './vue.esm-browser.js'
import { UAServer } from "./ua_server.js"

var onMessage = () => {}
var onNodeSelected = () => {}
var uaServer = null

function getWebSocketUrl() {
  let l = window.location
  let protocol = l.protocol === 'https:' ? "wss://" : "ws://"
  let url = protocol + l.host + l.pathname + "opcua_client.lsp"
  // const url = "ws://localhost/opcua_client.lsp";
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
        endpointUrl: "opc.tcp://localhost:4841",
        connected: false,
        endpoints: [],
        selectedEndpointIndex: 0
      }
    },
    methods: {
      async connect() {
        try {
          this.root.nodes = []
          onNodeSelected(null)
          this.connected = false

          onMessage("msg", "Connecting to websocket " + getWebSocketUrl())
          uaServer = await new UAServer(getWebSocketUrl())
          onMessage("msg", "Web socket connected");

          let endpoint = this.endpoints[this.selectedEndpointIndex]
          onMessage("msg", "Connecting to endpoint " + this.endpointUrl)
          await uaServer.connectEndpoint(this.endpointUrl)
          onMessage("msg", "Opening secure channel")
          await uaServer.openSecureChannel(3600000, endpoint.securityPolicyUri, endpoint.securityMode, endpoint.serverCertificate)
          onMessage("msg", "Creating session")
          await uaServer.createSession("web_client_session", 3600000)
          onMessage("msg", "Activating session")
          await uaServer.activateSession()
          onMessage("msg", "Connected")
          this.connected = true;
        } catch (e) {
          onMessage("msg", "Cannot connect to OPCUA server", e)
          this.connected = false
          uaServer = null
        }
      },

      async fillSecurePolicies ()
      {
        try {
          onMessage("msg", "Connecting to websocket " + getWebSocketUrl())
          let discoveryServer = await new UAServer(getWebSocketUrl());
          onMessage("msg", "Connecting to endpoint " + this.endpointUrl)
          await discoveryServer.connectEndpoint(this.endpointUrl)
          onMessage("msg", "Opening unsecure channel")
          await discoveryServer.openSecureChannel(5000)
          onMessage("msg", "Selecting endpoints")
          let resp = await discoveryServer.getEndpoints()
          let endpoints = resp.endpoints;
          onMessage("msg", "Selected " + endpoints.length + " endpoints")
          endpoints.forEach((val, idx, arr) => {
            arr[idx].policyName = discoveryServer.getPolicyName(val.securityPolicyUri);
            arr[idx].securityModeName = discoveryServer.getMessageModeName(val.securityMode);
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

          onMessage("msg", "Closing channel")
          await discoveryServer.closeSecureChannel()
          onMessage("msg", "Disconnecting OPCUA server")
          await discoveryServer.disconnect()
        }
        catch (err)
        {
          onMessage("err", err)
        }
      }    
    }
})

app.component("ua-attributes", {
    template:
    '\
        <div>\
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
        // visible() {
        //     return this.attributes.length != 0
        // }
    },
    methods: {
        async readAttributes(nodeId) {
          try {
            if (nodeId === null)
            {
              this.attributes = []
              return
            }

            onMessage("msg", "reading attribites of nodeID " + nodeId)
            let resp = await uaServer.read(nodeId)
            let attrs = []
            resp.results.forEach( (attr,index) => {
                if ((typeof(attr.statusCode) != "undefined" && attr.statusCode != 0) || typeof(attr.value) == "undefined")
                    return

                attrs.push({
                    name: uaServer.getAttributeName(index),
                    value: JSON.stringify(attr.value, null, "  ")
                })
            });

            this.attributes = attrs
          } catch (e) {
            this.attributes = []
            onMessage("err",  e)
          }
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
        async browse() {
          if (this.root.nodes.length != 0)
          {
            this.root.nodes = []
            return
          }

          onMessage("msg", "Browsing nodeID " + this.root.nodeid)
          let resp = await uaServer.browse(this.root.nodeid)
          let nodes = []
          resp.results.forEach(result => {
            result.references.forEach(ref => {
              nodes.push({
                  nodeid: ref.nodeId,
                  label: ref.browseName.name,
                  nodes: []
              })
            })
          });

          this.root.nodes = nodes
        },
        selectNode: function() {
          onNodeSelected(this.root.nodeid);
        }
    }
})

app.component("ua-messages", {
  template:
  '\
    <div class="ua-messages">\
      <div class="ua-messages-top">\
        <button v-on:click.prevent="cleaMessages">Clear messages</button>\
      </div>\
      <div class="ua-messages-content">\
        <table class="ua-messages-table">\
          <tr class="ua-messages-tr" v-for="msg in messages">\
            <td class="ua-messages-td">{{msg.time}}</td>\
            <td class="ua-messages-td">{{msg.message}}</td>\
            <td class="ua-messages-td"><pre>{{msg.details}}</pre></td>\
          </tr>\
        </table>\
      </div>\
    </div>\
  ',
  data() {
      return {
          messages: [
          ],
      }
  },
  mounted() {
    onMessage = (msg, det) => {
      const tnow = new Date().toISOString()
      this.messages.unshift({
        time: tnow,
        message: msg,
        details: det})
    } 
  },
  methods: {
    cleaMessages() {
      this.messages = []
    }
  }
})


app.mount('#opcua-client-app')
