import { createApp, toHandlers } from './vue.esm-browser.js'
import { UAServer } from "./ua_server.js"

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

          console.info("Connecting to endpoint ")
          uaServer = await new UAServer(getWebSocketUrl())
          console.log("Web socket connected");

          let endpoint = this.endpoints[this.selectedEndpointIndex]
          await uaServer.connectEndpoint(this.endpointUrl)
          await uaServer.openSecureChannel(3600000, endpoint.securityPolicyUri, endpoint.securityMode, endpoint.serverCertificate)
          await uaServer.createSession("web_client_session", 3600000)
          await uaServer.activateSession()
          this.connected = true;
        } catch (e) {
          console.log("Web socket disconnected:" + (e ? e : ""));
          this.connected = false
          uaServer = null
        }
      },

      async fillSecurePolicies ()
      {
        try {
          let discoveryServer = await new UAServer(getWebSocketUrl());
          await discoveryServer.connectEndpoint(this.endpointUrl)
          await discoveryServer.openSecureChannel(5000)
          let resp = await discoveryServer.getEndpoints()
          let endpoints = resp.endpoints;
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

          await discoveryServer.closeSecureChannel()
          await discoveryServer.disconnect()
        }
        catch (err)
        {
          alert(err)
        }
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
        async readAttributes(nodeId) {
          try {
            if (nodeId === null)
            {
              this.attributes = []
              return
            }

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
            console.error(e)
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

app.mount('#opcua-client-app')
