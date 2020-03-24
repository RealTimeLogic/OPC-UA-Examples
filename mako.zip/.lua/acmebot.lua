local acme=require"acme"
local hio=ba.openio"home"
local fmt=string.format

local optionT
local status={}

if not hio:stat"cert" and not hio:mkdir"cert" then
   error("Cannot create "..hio:realpath"cert")
end

local function log(flush,fmts,...)
   local msg=fmt("ACME: "..fmts,...)
   tracep(false,flush and 0 or 2,msg)
   if mako.daemon then
      local op = flush and {flush=true} or {ts=true}
      mako.log(msg,op)
   end
end

local rw=require"rwfile"
local function jfile(name,tab)
   return rw.json(hio,fmt("cert/%s.json",name),tab)
end
local function cfile(name,cert)
   return rw.file(hio,fmt("cert/%s.pem",name),cert)
end


local function getproxy(op)
   pcall(function()
            local pT=require"loadconf".proxy
            op.proxy,op.proxyport,op.socks=pT.name,pT.port,pT.socks
            op.proxyuser,op.proxypass=pT.proxyuser,pT.proxypass
         end)
   return op
end


-- ASN1 time format: YYMMDDHHMMSSZ
local function time2renew(asn1exptime)
   local y,m,d=asn1exptime:match"(%d%d)(%d%d)(%d%d)(%d%d)(%d%d)(%d%d)Z"
   if y and m and d then
      y,m,d=tonumber(y),tonumber(m),tonumber(d)
      if y and m and d then
	 local exptime=os.time{year=y+2000,month=m,day=d}
	 -- Renew no later than 22 days before exp.
	 return (exptime - 1900800) < os.time()
      end
   end
   return true
end

local function getKeyCertNames(domain)
   return fmt("cert/%s.key.pem",domain),fmt("cert/%s.cert.pem",domain)
end


local function loadcerts(domainsT)
   domainsT=domainsT or jfile"domains" or {}
   local keys,certs={},{}
   for domain, exptime in pairs(domainsT) do
      if #exptime > 0 then
	 local k,c=getKeyCertNames(domain)
	 if hio:stat(k) and hio:stat(c) then
	    table.insert(keys,k)
	    table.insert(certs,c)
	 else
	    log(true,"not found: %s",hio:stat(k) and c or k)
	 end
      end
   end
   if #keys > 0 then
      mako.loadcerts(keys,certs)
   end
end

local function renew(accountT,domain)
   local function rspCB(key,cert)
      status={domain=domain}
      if key then
	 local domainsT=jfile"domains" or {}
	 domainsT[domain]=ba.parsecert(
            ba.b64decode(cert:match".-BEGIN.-\n%s*(.-)\n%s*%-%-")).tzto
	 cfile(domain..".key",key)
	 cfile(domain..".cert",cert)
	 jfile("domains",domainsT)
	 jfile("account",accountT)
	 log(false,"%s renewed",domain)
	 loadcerts(domainsT)
      else
         status.err=cert
	 log(true,"renewing %s failed: %s",domain,cert)
      end
   end
   acme.cert(accountT,domain,rspCB,optionT)
end

local function check(forceUpdate)
   if acme.jobs() > 0 then
      log(false,"Cannot check certs: acme busy")
      return false
   end
   local domainsT=jfile"domains"
   local accountT=jfile"account"
   if not domainsT then log(true,"Cannot open domains.json") return end
   if not accountT then log(true,"Cannot open account.json") return end
   for domain,exptime in pairs(domainsT) do
      if forceUpdate or time2renew(exptime) then renew(accountT,domain) end
   end
   return true
end

local function configure(email,domains,op)
   optionT=getproxy(op or {})
   assert((not email or type(email)=='string') and
	  (not domains or ((type(domains)=='table' and
           type(domains[1])=='string'))),
          "Invalid args or 'acme' table in mako.conf")
   local accountT=jfile"account" or {}
   if email and accountT.email ~= email then
      accountT.email,accountT.id=email,nil
      jfile("account",accountT)
   end
   if not domains then return true end
   local oldDomsT=jfile"domains" or {}
   local newDomsT={}
   for _,dn in ipairs(domains) do
      newDomsT[dn]=oldDomsT[dn] or "" -- renew-date or new
   end
   local oldDomsT=jfile"domains" or {}
   if optionT.cleanup then
      for dn in pairs(oldDomsT) do
         if not newDomsT[dn] then
            local k,c=getKeyCertNames(dn)
            hio:remove(k)
            hio:remove(c)
         end
      end
   end
   if not optionT.noDomCopy then -- Set by acmedns : auto update
      jfile("domains",newDomsT)
   end
   return true
end


local timer
local function autoupdate(activate)
   if activate then
      if timer then return false end
      if jfile"domains" then ba.thread.run(check) end
      timer=ba.timer(check)
      timer:set(24*60*60*1000) -- once a day
   else
      if not timer then return false end
      timer:cancel()
      timer=nil
   end
   return true
end

local function renew()
   if timer then return nil,"autoupdate" end
   if not jfile"domains" then return nil,"inactive" end
   if acme.jobs() > 0 then return nil,"busy" end
   status={}
   return check(true)
end


local function getcfg()
   local aT = require"loadconf".acme
   assert(type(aT.email) == 'string', "acme: Invalid domain") 
   assert(type(aT.domains[1]) == 'string', "acme: Invalid domain")
   return aT,{production=aT.production,rsa=aT.rsa,bits=aT.bits,
      acceptterms=true,info=aT.info}
end

-- Called by .config if acme options set
function cfgFileActivation()
   local aT,op=getcfg()
   configure(aT.email,aT.domains,op)
   autoupdate(true)
end


require"seed" -- seed sharkssl
loadcerts()

return {
   start = function() return autoupdate(true) end,
   configure=configure,
   getdomains=function() return jfile"domains" or {} end,
   status=function() return acme.jobs(), status.domain, status.err end,
   getproxy=getproxy,
   pdns={ -- private: used by acmedns
      autoupdate=autoupdate,
      getcfg=getcfg,
      jfile=jfile,
      renew=renew,
      setErr=function(msg) log(true,"%s",msg) status={err=msg} end,
   },
   cfgFileActivation=cfgFileActivation -- Called by .config if acme options
}
