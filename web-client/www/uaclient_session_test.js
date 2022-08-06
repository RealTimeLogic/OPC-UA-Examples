import { UAServer } from "./ua_server.js"

function assertTrue(exp) {
  if (exp === true)  
    return

  throw new Error("Fail")
}


// let l = window.location
// let protocol = l.protocol === 'https:' ? "wss://" : "ws://"
// let webSocketUrl = protocol + l.host + l.pathname + "opcua_client.lsp"
let webSocketUrl = "ws://localhost/opcua_client.lsp";


{
  let resp
  let uaServer = await new UAServer(webSocketUrl)

  let timeoutMs = 3600000
  resp = await uaServer.connectEndpoint("opc.tcp://localhost:4841")
  assertTrue(resp === undefined)

  resp = await uaServer.openSecureChannel(timeoutMs)
  assertTrue(resp.serverProtocolVersion === 0)

  resp = await uaServer.createSession("test_session", timeoutMs)
  assertTrue(resp.serverEndpoints.length !== 0)

  resp = await uaServer.activateSession()
  assertTrue(resp.results.length === 1)
  assertTrue(resp.results[0] === 0)

  resp = await uaServer.getEndpoints()
  assertTrue(resp.endpoints.length !== 0)

  resp = await uaServer.browse("i=84")
  assertTrue(resp.results.length !== 0)

  resp = await uaServer.read("i=84")
  assertTrue(resp.results.length === 27)

  resp = await uaServer.closeSession()
  assertTrue(resp.responseHeader.serviceResult === 0)

  resp = await uaServer.closeSecureChannel()
  assertTrue(resp === undefined)

  resp = await uaServer.disconnect();
  assertTrue(resp === undefined)
}
