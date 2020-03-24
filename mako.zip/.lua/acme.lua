
-- SPEC: https://ietf-wg-acme.github.io/acme/draft-ietf-acme-acme.html

local dURL = { -- ACME service's directory (discover) URL
   production="https://acme-v02.api.letsencrypt.org/directory",
   staging="https://acme-staging-v02.api.letsencrypt.org/directory"
}

 -- getCert queue: list of {account=obj,rspCB=func,op=obj,getCertCO=coroutine}
local jobQ={}
local jobs=0

local schar,slower=string.char,string.lower

local ue=ba.urlencode
local function aue(x) return ue(ue(x)) end -- ACME url encode

local function errlog(url, msg)
   tracep(false, 5, "ACME error, URL:",url,"\n",msg,"\n",debug.traceback("", 2))
   return nil,msg
end

local function respErr(err, rspCB)
   if type(err) == 'table' then
      local error = err.error or err
      err = error.detail or ba.json.encode(err)
   end
   rspCB(nil,err)
   return nil,err
end

-- Parses an X.509 ECC private key in PEM format and
-- returns privatekey, x, y
-- Designed exclusively for the secp256k1 curve.
local function decodeEccPemKey(key)
   key = ba.b64decode(key:match"KEY.-%s+([%w%s=+/]+)":gsub("%s+",""))
   -- Private key starts at pos 8
   local privkey=key:sub(8,39)
   -- 03: ASN.1 bit string, 4200: length, 04: ECC uncompressed form
   local pubkey = key:sub(key:find(schar(3,0x42,0,4),50,true)+4)
   assert(#pubkey == 64)
   local x,y = pubkey:sub(1,32),pubkey:sub(33)
   return ba.b64urlencode(privkey), ba.b64urlencode(x), ba.b64urlencode(y)
end

-- Table 't' to JSON and URL safe B64 enc.
local function jsto64(t)
   return ba.b64urlencode(ba.json.encode(t))
end

-- Returns: "ACME http func", dir listing, nonce
local function createAcmeHttp(op)
   local shark,trusted
   if op.shark or mako then
      op.shark=op.shark or mako.sharkclient()
      trusted=true
   else
      tracep(false,5,"Warning: not validating certificate from letsencrypt.org")
      op.shark=ba.create.sharkssl(ba.create.certstore())
      trusted=false
   end
   local http=require"http".create(op)
   local function ahttp(url, json, getraw) -- ACME HTTP func
      local ok,err
      if json then
	 local data=ba.json.encode(json)
	 ok,err=http:request{
            trusted=trusted,
	    url=url,
	    method="POST",
	    size=#data,
	    header={['Content-Type']='application/jose+json'}
	 }
	 http:write(data)
      else
	 ok,err=http:request{url=url,trusted=trusted}
      end
      if not ok then
         err = string.format("%s err: %s", op.proxy and "proxy" or "HTTP",err)
	 return errlog(url, err)
      end
      local status = http:status()
      local ok = status == 200 or status == 201 or status == 204
      local rsp=http:read"*a"
      if not ok then
	 err = rsp or string.format("HTTP err: %d", status)
	 errlog(url, err)
      end
      if getraw then
	 if ok then return rsp end
	 return nil, err
      end
      rsp = rsp and ba.json.decode(rsp)
      local h = http:header()
      local h={}
      for k,v in pairs(http:header()) do h[slower(k)]=v end
      return ok, (rsp or err), h["replay-nonce"], h
   end -- ACME http func
   local ok, dir = ahttp(op.production and dURL.production or dURL.staging)
   if ok then
      ok, rsp, nonce = ahttp(dir.newNonce) -- Get the first nonce
      if ok then return ahttp, dir, nonce end
      dir=rsp
   end
   return false, dir
end

local function sign(hash, key)
   local r,s = ba.crypto.der2ecdsa(ba.crypto.sign(hash,key))
   return ba.b64urlencode(r..s)
end

local function hashsign(data, key)
   return sign(ba.crypto.hash"sha256"(data)(true), key)
end


local function resumeCo(...)
   assert(#jobQ > 0)
   local args={...}
   ba.thread.run(function()
      local job = jobQ[1]
      local ok,err = coroutine.resume(job.getCertCO, table.unpack(args))
      if not ok then
         errlog("", err)
      end
      if not ok or coroutine.status(job.getCertCO) == "dead" then
         table.remove(jobQ, 1)
         jobs=jobs-1
         if #jobQ > 0 then resumeCo(jobQ[1]) end
      end
   end)
end

-- The default HTTP challenge
local function httpChallengeIntf()
   local dir
   local function insert(tokenURL, keyAuth, rspCB)
      local function wellknown(_ENV, rel)
         if tokenURL==rel then
            response:setcontenttype"application/octet-stream"
            response:setcontentlength(#keyAuth)
            response:send(keyAuth)
            return true
         end
         return false
      end
      dir = ba.create.dir(".well-known",1)
      dir:setfunc(wellknown)
      dir:insert()
      rspCB(true)
   end
   local function remove(rspCB)
      dir:unlink()
      rspCB(true)
   end
   return {insert=insert,remove=remove}
end

local function getCertCOFunc(job)
   local account,op=job.account,job.op
   local op=job.op
   local dnsch
   if op.ch then
      dnsch = op.ch.set and true
   else
      op.ch=httpChallengeIntf()
   end
   local function retErr(err) respErr(err, job.rspCB) end
   local ok,rsp,nonce,h -- ret values from ACME HTTP
   local http, dir -- ACME HTTP and directory listing
   http, dir, nonce = createAcmeHttp(op)
   if not http then return retErr(dir) end

   local newAccount
   -- Create the accountKey (pem) and extract the private key and the
   -- public key (x,y) components
   local pkey,x,y
   if account.id and account.key then
      newAccount=false
      pkey,x,y=decodeEccPemKey(account.key)
   else
      newAccount=true
      account.key = account.key or ba.create.key()
      pkey,x,y=decodeEccPemKey(account.key)

      -- Prepare for new account request
      local payload64=jsto64{
	 termsOfServiceAgreed=true,
	 onlyReturnExisting=false,
	 contact={'mailto:'..account.email},
      }
      local protected64=jsto64{
	 nonce=nonce,
	 url=dir.newAccount,
	 alg='ES256',
	 jwk={
	    kty="EC",
	    crv="P-256",
	    x=x,
	    y=y,
	 }
      }
      local data = { -- Signed Account Data
	 protected=protected64,
	 payload=payload64,
	 signature= hashsign(protected64.."."..payload64, account.key),
      }
      -- Send account request
      ok,rsp,nonce,h = http(dir.newAccount, data)
      if not ok then return retErr(rsp) end
      account.id=h.location
   end

   -- Prepare the order
   payload64 = jsto64{
      identifiers = {
	 { type='dns', value=job.domain }
      }
   }
   protected64 = jsto64{
      nonce=nonce, alg='ES256', url=dir.newOrder, kid=account.id}
   data = { -- Signed Order
      protected=protected64,
      payload=payload64,
      signature=hashsign(protected64.."."..payload64, account.key),
   }
   -- Send order request
   ok,rsp,nonce,h = http(dir.newOrder, data)
   if not ok then
      if newAccount==false then
	 account.key,account.id=nil,nil
	 return getCertCOFunc(job)
      end
      return retErr(rsp)
   end
   local currentOrderURL=h.location
   local authURL=rsp.authorizations[1]
   local finalizeURL=rsp.finalize

   -- The authURL returns a list of possible challenges.
   ok,rsp = http(authURL)
   if not ok then return retErr(rsp) end
   local token,challengeUrl
   for _,ch in ipairs(rsp.challenges) do -- Find the HTTP challenge option
      if (not dnsch and ch.type=="http-01") or (dnsch and ch.type=="dns-01") then
	 -- Fetch the token and HTTP challenge URL
	 token,challengeUrl = ch.token,ch.url
	 break
      end
   end
   if not challengeUrl then
      return retErr(string.format("%s-01 challenge err",
				  dnsch and "dns" or "http"))
   end

   -- Canonical (sorted) JWK fingerprint (fp)
   local fp=string.format('{"crv":"P-256","kty":"EC","x":"%s","y":"%s"}',x,y)
   local thumbprint=ba.b64urlencode(ba.crypto.hash"sha256"(fp)(true))
   local keyAuth = token..'.'..thumbprint;
   if dnsch then
      local dnsAuth = ba.b64urlencode(ba.crypto.hash"sha256"(keyAuth)(true))
      local dnsRecord = '_acme-challenge.'..job.domain;
      op.ch.set(dnsRecord, dnsAuth, resumeCo)
   else
      local tokenURL="acme-challenge/"..token
      op.ch.insert(tokenURL, keyAuth, resumeCo)
   end
   ok,rsp = coroutine.yield()
   if not ok then return retErr(rsp or "Start: challenge API") end

   payload64 = ba.b64urlencode"{}"
   protected64 = jsto64{
      nonce=nonce, alg='ES256', url=aue(challengeUrl), kid=account.id}
   data = {
      protected=protected64,
      payload=payload64,
      signature=hashsign(protected64.."."..payload64, account.key),
   }
   -- Initiate challenge. ACME now calls our 'wellknown' dir or checks DNS rec.
   ok, rsp, nonce, h = http(challengeUrl, data)
   if not ok then return retErr(rsp) end
   local challengePollURL = rsp.url
   local cnt=0
   -- Loop and poll the 'challengePollURL'
   local mcnt = dnsch and 60 or 10
   while true do
      cnt = cnt+1
      if cnt > mcnt then ok,rsp=false,"Challenge timeout" break end
      ba.sleep(3000)
      ok,rsp = http(challengePollURL)
      if not ok then break end
      if rsp.status ~= "pending" and rsp.status ~= "processing" then
	 if rsp.status ~= "valid" then ok=false end
	 break
      end
   end
   op.ch.remove(resumeCo)
   local ok2,rsp2 = coroutine.yield()
   if not ok then return retErr(rsp) end
   if not ok2 then return retErr(rsp2 or "End: challenge API") end

   -- Create the CSR
   local certtype = {"SSL_CLIENT", "SSL_SERVER"}
   local keyusage = {"DIGITAL_SIGNATURE", "KEY_ENCIPHERMENT"}
   local certKey=ba.create.key{
      key = op.rsa==true and "rsa" or "ecc", bits=op.bits}

   local csr=ba.create.csr(
     certKey,{commonname=job.domain},certtype,keyusage)
   -- Convert CSR to raw URL-safe B64
   csr=ba.b64urlencode(ba.b64decode(csr:match".-BEGIN.-\n%s*(.-)\n%s*%-%-"))
   payload64=jsto64{csr=csr}
   protected64=jsto64{nonce=nonce,alg='ES256',url=aue(finalizeURL),kid=account.id}
   data = {
      protected=protected64,
      payload=payload64,
      signature=hashsign(protected64.."."..payload64, account.key)
   }
   -- Send the CSR
   ok, rsp = http(finalizeURL, data)
   if not ok then return retErr(rsp) end

   if rsp.status ~= "valid" then -- If not ready
      cnt=0
      -- Loop and poll the 'challengePollURL'
      while true do
	 cnt = cnt+1
	 if cnt > 10 then return retErr"CSR response timeout" end
	 ba.sleep(3000)
	 ok, rsp = http(currentOrderURL)
	 if not ok then return retErr(rsp) end
	 if rsp.status == "valid" then break end
      end
   end
   local cert,err = http(rsp.certificate, nil, true)
   if not cert then return retErr(err) end
   job.rspCB(certKey, cert)
   return true
end


local function getCert(account, domain, rspCB, op)
   if op.acceptterms~=true then
      ba.thread.run(function() rspCB(nil, "No acceptterms") end)
      return
   end
   assert(type(domain) == 'string' and
          type(account.email) == 'string' and type(rspCB) == 'function')
   op=op or {}
   if op.ch then
      assert(type(op.ch.remove) == "function")
      if op.ch.set then
         assert(type(op.ch.set) == "function" and not op.ch.insert)
      else
         assert(type(op.ch.insert) == "function" and not op.ch.set)
      end
   end
   local job={account=account, domain=domain,rspCB=rspCB, op=op,
      getCertCO=coroutine.create(getCertCOFunc)}
   local empty = #jobQ == 0
   table.insert(jobQ, job)
   jobs=jobs+1
   if empty then resumeCo(jobQ[1]) end
   return jobs
end

local function revokeCert(account,cert,rspCB, op)
   http, dir, nonce = createAcmeHttp(op or {})
   local payload64 = jsto64{certificate=
      ba.b64urlencode(ba.b64decode(cert:match".-BEGIN.-\n%s*(.-)\n%s*%-%-"))}
   local protected64 = jsto64{
      nonce=nonce, alg='ES256', url=dir.revokeCert, kid=account.id}
   local data = {
      protected=protected64,
      payload=payload64,
      signature=hashsign(protected64.."."..payload64, account.key),
   }
   local ok, rsp = http(dir.revokeCert, data)
   if ok then
      rspCB(true)
   else
      respErr(rsp, rspCB)
   end
end

local function terms()
   local ok, dir = createAcmeHttp{}
   return ok and dir.meta.termsOfService or "https://letsencrypt.org/"
end

return {
   terms=terms,
   cert=getCert,
   jobs=function() return jobs end,
   revoke=function(account,cert,rspCB)
      ba.thread.run(function() revokeCert(account,cert,rspCB) end) end,
   ahttp=createAcmeHttp,
}

