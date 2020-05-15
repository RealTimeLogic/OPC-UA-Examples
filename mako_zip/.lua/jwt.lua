
local function jsto64(t) return ba.b64urlencode(ba.json.encode(t)) end

local function sign(key, payload, header)
   header=header or {alg="ES256",typ="JWT"}
   local signature,err
   local protected=jsto64(header)
   payload=type(payload) == "string" and payload or jsto64(payload)
   local data=protected.."."..payload
   if header.alg == "ES256" then
      local hash=ba.crypto.hash"sha256"(data)(true)
      hash,err=ba.crypto.sign(hash,key)
      if not hash then return nil,err end
      local r,s = ba.crypto.der2ecdsa(hash)
      signature=ba.b64urlencode(r..s)
   elseif header.alg == "HS256" then
      signature=ba.b64urlencode(ba.crypto.hash("hmac","sha256",key)(data)(true))
   else
      error"Non supported alg"
   end
   return {
      protected=protected,
      payload=payload,
      signature=signature
   }
end

local function scomp(key, payload, header)
   local t,err = sign(key, payload, header)
   if t then
      return string.format("%s.%s.%s",t.protected,t.payload,t.signature)
   end
   return nil,err
end


return {sign=sign,scomp=scomp}
