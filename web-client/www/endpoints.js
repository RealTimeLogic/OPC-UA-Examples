import { UAServer } from "./ua_server.js"

export default {
  props: {
    websocketUrl: {
      type: String,
      required: false
    }
  },
  data() {
    return {
      uaServer: new UAServer({
        onConnected: () => { this.connected = true },
        onDisconnected: (e) => { 
          this.connected = false;
          this.endpoints = []
        }
      }),
      connected: false,
      webSocketUrl: "ws://localhost/opcua_client.lsp",
      endpointUrl: "opc.tcp://localhost:4841",
      endpoints: [
      ]
    }
  },
  mounted() {
    //      let l = window.location
    //      let protocol = l.protocol === 'https:' ? "wss://" : "ws://"
    //      let url = protocol + l.host + l.pathname + "opcua_client.lsp"

    let url = this.webSocketUrl
    // console.info("Connecting to Websocket " + url)
    this.uaServer.connect(url)
  },
  methods: {
    connectEndpoint() {
        if (!this.connected)
          return;

        this.uaServer.connectEndpoint({endpointUrl: this.endpointUrl} , (resp) => {
          this.endpoints = []
          this.uaServer.getEndpoints({}, this.fillEndpoints);
      })
    },
    fillEndpoints(resp) {
      if (resp.error)
      {
        alert(resp.error)
        return
      }

      let endpoints = resp.endpoints;
      endpoints.forEach((val, idx, arr) => {
        arr[idx].policyName = this.uaServer.getPolicyName(val.securityPolicyUri);
        arr[idx].securityModeName = this.uaServer.getMessageModeName(val.securityMode);
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
  },
  template: `
    <div class="endpoints-panel" :class="[connected ? 'endpoints-panel-connected' : 'endpoints-panel-disconnected']">
    <form class="endpoints-form">
      <label class="endpoints-server-label" for="serverUrl">Server URL</label>
      <input class="endpoints-server-url" v-model="endpointUrl" id="serverUrl" placeholder="" v-bind:disabled="!connected">
      <input class="endpoints-button-list" type="button" value="Get Endpoints" @click="connectEndpoint" v-bind:disabled="!connected">
    </form>

    <form class="endpoints-form endpoints-form-vertical">
        <fieldset>
          <table>
            <tr v-for="(endpoint, index) in endpoints">
              <td>
                <input type="radio" v-bind:id="endpoint.id" name="basic12rsa" value="basic12rsa">
              </td>
              <td>
                <label v-bind:for="endpoint.id">{{ endpoint.policyName }}</label>
              </td>
              <td>
                <label v-bind:for="endpoint.id">{{ endpoint.securityModeName }}</label>
              </td>
            </tr>
          </table>
        </fieldset>
        <div class="endpoints-row-delimiter"></div>
        <input type="button" value="OK" v-bind:disabled="!connected">
    </form>
    </div>
  `
}
