local ua = require("opcua.api")
local compat = require("opcua.compat")

local traceI = ua.trace.inf
local traceD = ua.trace.dbg
local traceE = ua.trace.err


local isWorking = false
local serverThread = compat.thread.create()
local server = nil

local function serverLoop(config)
  traceI("creating OPCUA server")
  local s = ua.newServer(config)
  traceI("initializing OPCUA server")
  s:initialize()
  traceI("run OPCUA server")
  s:run()
  server = s

  traceI("waiting for stop event")

  isWorking = true
  while isWorking do
    compat.sleep(1)
  end
  traceI("shutting down OPCUA server")

  s:shutdown()
  server = nil
  traceI("OPCUA server destroyed")
end

local function stopServer()
  traceI("stopping server")
  if not server then
    traceI("server not started")
    return
  end

  isWorking = false
  while server do
    traceI(".")
    compat.sleep(1)
  end
  traceI("server stopped")
end

local serverCertificatePem =
[[
  -----BEGIN CERTIFICATE-----
  MIIDbDCCAlQCFCyh4dzsPsMZO+1L/j8An1BaclAaMA0GCSqGSIb3DQEBCwUAMIGF
  MQswCQYDVQQGEwJSVTETMBEGA1UECAwKU29tZS1TdGF0ZTEPMA0GA1UEBwwGTW9z
  Y293MQ8wDQYDVQQKDAZQcm9zeXMxGDAWBgNVBAMMD2FyeWtvdmFub3Ytbm90ZTEl
  MCMGCSqGSIb3DQEJARYWcnlrb3Zhbm92LmFzQGdtYWlsLmNvbTAeFw0yMjAxMDkx
  MzUyNThaFw0zNTA5MTgxMzUyNThaMF8xCzAJBgNVBAYTAlJVMQ8wDQYDVQQHDAZN
  b3Njb3cxGDAWBgNVBAMMD2FyeWtvdmFub3Ytbm90ZTElMCMGCSqGSIb3DQEJARYW
  cnlrb3Zhbm92LmFzQGdtYWlsLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
  AQoCggEBALmhXf3vAXSNYvGmBVrtniAufFB9T+UDOdw5WBmhQZRgiMc71LPELEc+
  wZNHVrsgbagwXkMUlA9mfIF08wP0oLHeCXpCt1uO6L3JFKYgcFXqFO4T2VarNW9t
  P+WKuadG95y3Gzj4uiuXNIgt1pVr7b3rvmjko6G7ppVFcsqqg9l6rBbPj3UEaZ78
  ihfKtzjvHnNCHnS5WhGR8KtN/WIIo98QbfuNxLTzaNHtzHWMRI1pqaiAWobdSweo
  OIOH85LYWvj6dBKBNhGHyGzkvwQcQtbCabBsv6o/NYP4sbKpGmyBc3hmKqKDs0VP
  BPbjov7vk4DpjLqv3nodp3ejtKL/asUCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEA
  cwOyFSjzHFaCZJZN8rX7cK6WCCkzalApRgtUFV3RnHk+30xFrMtPpoKVyAUv903j
  G97aZpFLxCp7A73xqon2sNjDecJ4Z+NjpV8OC1ToyBexddc1i6++bcghutiDwhaP
  krLL/AULqr6yPQxQW55MOrw2hnK54QyvR38DWdDJfWWRG9Ldaa1f0HlJOkIT1poI
  CU4SqqSsaQSLr/1m310XCYeetY4jCSEpRPwnxnX+PytImrfe5IfhjGBeHzSYxKhc
  Bl5OMutBj30V7IyXEGj9Y0evGgMsDsoLah4e4nrJqaxD1JJhy0y7bapwK+fe4XEX
  KiM2dXbn22w3UpESUDrNWg==
  -----END CERTIFICATE-----
]]

local serverKeyPem =
[[
  -----BEGIN RSA PRIVATE KEY-----
  MIIEowIBAAKCAQEAuaFd/e8BdI1i8aYFWu2eIC58UH1P5QM53DlYGaFBlGCIxzvU
  s8QsRz7Bk0dWuyBtqDBeQxSUD2Z8gXTzA/Sgsd4JekK3W47ovckUpiBwVeoU7hPZ
  Vqs1b20/5Yq5p0b3nLcbOPi6K5c0iC3WlWvtveu+aOSjobumlUVyyqqD2XqsFs+P
  dQRpnvyKF8q3OO8ec0IedLlaEZHwq039Ygij3xBt+43EtPNo0e3MdYxEjWmpqIBa
  ht1LB6g4g4fzktha+Pp0EoE2EYfIbOS/BBxC1sJpsGy/qj81g/ixsqkabIFzeGYq
  ooOzRU8E9uOi/u+TgOmMuq/eeh2nd6O0ov9qxQIDAQABAoIBABLbw/LCT0GKA51N
  IookTcYzMsnykSVQ+JXY9YxVB5aNYBftiiRhL6ZlR8EwpC0KlFlb4JesBYazAL8e
  JHooZhLr3caf9ITGtfph7UkbTo5L46h0N8ZISntxe+ZT+5x05z7ykz9sdW1sRRf4
  oC458sMyqft6Du2lZL0ReyH/xLlZQsrn3OztReDwv61yRM+69NnI/q88DN/QQAxg
  EdO0lkiJvslT95ILe4Kd5trQSH0u5zVWZY4DPZbU5NrzqXiC5oqTySF2EdhA+Pmv
  tt6x7i2ySpZ8FwYIvF8zcPzkjRaS3R3qtmVyyDdOe9Th8IogcJUtepFxVSDNBTA8
  LECzIFkCgYEA29aXkNskJ0ggOLMzCEp9T7je51yRFLHZs05QCDxM5vZa75/XQ+9c
  kHca1gKjc3mSbI2irf+DkCridYaCPOxPRqWD15CU6PML0IOaSKhQuwx7j6LMlgSW
  YjS3aFsW1zEyWDwqs30QSm3DgxEXl2oC9eiBvBXldQgHYPdf2HMc6sMCgYEA2CpG
  62wwlrC7iOg/ULqfdrna7i8y9LYI/W9xh83lzXnlHuJV9YFqVlAoV4vIAdpEHS6k
  9uAP/4gCmgGxfeRFmP+hOaSivBLDl4fBVAuibqh/5o7eUReOvaBQlRNg+HEQXi9l
  hIVMvePScTwWbgLahE9ZIwuIaOb4IYpwwD0iq9cCgYBIChY43dcHGFeWvQJoISDX
  UxmYb3kLcwyH+Y24ZSo+NVSvWY3NMU7/+EfPAaZWXOxirjc1FZojUCpNoPpkxHtm
  By8hILvralngxn90d9OcuAZ1lz+7mV0+aVAA3nipo/F/gJftoXoJKdb7yEoW0CKQ
  OtTosbQzmaHxYJ8D6xT6yQKBgGYAhRigI8lnugafeQkSFx9CEjHkqcnZgCJ/DPaF
  TRQJmflZ2jAQEmqKRo8REZ72LMAMe6FXF5V/y6J6fBOovMK2lZCKxJO00wDU+YA8
  QTiwYDIeZn+jeyK13HCMBW0WhR+8g83lzNGqCGqQbREaXZyjiK9FyOefXaUOG6hK
  8OpfAoGBAKONGzPOUuzvPliZHXi5AZ8uL4ZABJ7WQrz+303jrGMHwWnJsWvQnnX8
  fdSni6J9q21YzbGpmPebXqqYC7hmYEEwXvxNGC29HOXDWN4X8eNa89h8aX/3Ryhg
  9Otn4RqRsivHj7SoTgLATZGx1EYw+PHKtD8l5apjNuFBBVPo+2+x
  -----END RSA PRIVATE KEY-----
]]

local serverConfig = {
  endpoints = {
    {
      endpointUrl="opc.tcp://localhost:4841",
      listenPort=4841,
      listenAddress="*",
    }
  },

  certificate = serverCertificatePem,
  key =         serverKeyPem,

  securePolicies = {
    { -- #1
      securityPolicyUri = ua.SecurityPolicy.None,
    },
    { -- #2
      securityPolicyUri = ua.SecurityPolicy.Basic128Rsa15,
      securityMode = {ua.MessageSecurityMode.SignAndEncrypt, ua.MessageSecurityMode.Sign},
    }
  },
  userIdentityTokens = {
    {
      policyId = "anonymous_policy",
      tokenType = ua.UserTokenType.Anonymous,
    },
    {
      policyId = "cert_policy",
      tokenType = ua.UserTokenType.Certificate,
    },
    {
      policyId = "username_policy",
      tokenType = ua.UserTokenType.UserName,
    },
  }
}


local function startServer()
  traceI("starting new server")
  if server then
    traceI("stopping previous server")
    stopServer()
  end

  isWorking = true
  serverThread:run(function() serverLoop(serverConfig) end)

  traceI("waiting for server start")
  while not server do
    compat.sleep(1)
  end
end


return {
  start = startServer,
  stop  = stopServer
}
