import { createApp } from 'vue'
import  Endpoints  from './endpoints.js'

var app = createApp({
  data() {
    //      let l = window.location
    //      let protocol = l.protocol === 'https:' ? "wss://" : "ws://"
    //      let url = protocol + l.host + l.pathname + "opcua_client.lsp"

    let url = "ws://localhost/opcua_client.lsp"
    return {
      websocketUrl: url
    }
  }
})

app.component('Endpoints', Endpoints)

app.mount('#app-get-endpoints')
