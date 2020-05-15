
local ab=require"acmebot"
local abp=ab.priv -- Import private funcs
local fmt=string.format
local zoneKey,sURL,httpreq

local httpOptions
local function setHttpOptions(op)
   assert(type(op.shark) == "userdata", "no op. shark")
   httpOptions = mako and ab.getproxy(op) or op
end
if mako then setHttpOptions{shark=mako.sharkclient()} end

local sendEmail -- Can optionally be set using D.init
sendEmail=function(msg)
   if mako and mako.daemon then
      local op={flush=true}
      mako.log(nil, op)
      op.subject="Set ACME DNS TXT Record"
      mako.log(msg, op)
   end
end


local function checkCfg(level)
   if zoneKey then
      if type(zoneKey) ~= 'string' or #zoneKey ~= 64 then
         error("Invalid zone key",level or 2)
      end
   elseif not mako or not mako.bacmehttp then 
      error("Zone key not set",level or 2)
   end
end

local function configure(key,serviceUrl,level)
   zoneKey = key or zoneKey
   sURL = serviceUrl or sURL or "https://acme.realtimelogic.com/command.lsp"
   if zoneKey then
      httpreq=function(http,op) return http:request(op) end
   else
      httpreq=function(http,op) return mako.bacmehttp(http,op) end
   end
   checkCfg(level and level+1 or 3)
end


-- Lock/release logic for acme.lua's challenge CBs (rspCB).  The
-- function aborts any action if called with lock(nil,nil,true) and
-- only D.auto() and D.manual calls it this way.
local lock -- function set below
do
   local rspFailedCB
   local savedCleanupOnErrCB
   local emsg="ACME DNS cancelling pending job"
   lock=function(rspCB,cleanupOnErrCB,release)
      if rspFailedCB and release then
         abp.setErr(emsg)
         rspFailedCB()
         savedCleanupOnErrCB()
      end
      if rspCB then
         savedCleanupOnErrCB=cleanupOnErrCB
         rspFailedCB=function() rspCB(false,emsg) end
      else
         rspFailedCB,savedCleanupOnErrCB=nil,nil
      end
   end
end


local manualMode,active=false,false
local function checkM()
   if manualMode ~= true then error("Not in manual mode", 3) end
end
local function noActivation() checkM() return nil, "Challenge not active" end
local D={activate=noActivation, status=noActivation}

-- acme.lua's 'set' challenge CB for manual operation
local setManual
setManual=function(dnsRecord,dnsAuth,rspCB)
   if dnsRecord then -- activate
      -- call chain: acme.lua -> setManual
      local msg=string.format("\tRecord name:\t%s\n\tRecord data:\t%s",
                              dnsRecord, dnsAuth)
      D.status = function() return {record=dnsRecord,data=dnsAuth,msg=msg} end
      D.recordset=function() setManual() lock() rspCB(true) return true end
      lock(rspCB, setManual)
      tracep(false,0,"Set ACME DNS TXT Record:\n"..msg)
      sendEmail(msg,dnsRecord,dnsAuth)
   else -- release
      -- call chain D.recordset() -> setManual OR
      -- D.get -> lock -> savedCleanupOnErrCB=setManual
      D.status,D.recordset=noActivation,noActivation
   end
end


local function sockname(http)
   local ip,port,is6=http:sockname()
   if is6 and ip:find("::ffff:",1,true) == 1 then
      ip=ip:sub(8,-1) -- IPv4-mapped IPv6 address to IPv4
   end
   return ip
end


-- activateAuto code below
local function createHttp()
   local http=require"httpc".create(httpOptions)
   local function xhttp(command,hT,nolog)
      local hT=hT or {}
      hT['X-Command'],hT['X-Key']=command,zoneKey
      local ok,err=httpreq(http,{
         trusted=true,
         url=sURL,
         method="GET",
         size=0,
         header=hT
      })
      if not ok then
	 abp.setErr(fmt("%s Err: %s\nURL: %s",httpOptions.proxy and "Proxy" or "HTTP",err,sURL))
      end
      hT = http:header()
      local status = http:status()
      if status ~= 201 then
         if not nolog and status and hT then
            abp.setErr(fmt("HTTP Status=%d: %s\nURL: %s",status,hT["X-Reason"], sURL))
         end
         return nil, status, (hT and hT["X-Reason"] or err)
      end
      return hT
   end
   local hT,s,e=xhttp"GetWan"
   if hT then
      return xhttp, hT['X-IpAddress'], sockname(http)
   end
   return nil,s,e
end

local function register(http,sockname,domain,info)
   local hT={["X-IpAddress"]=sockname,["X-Name"]=domain,["X-Info"]=info}
   hT=http("Register", hT)
   if hT then
      local devKey,domain=hT['X-Dev'],hT['X-Name']
      assert(devKey and domain)
      abp.jfile("domains",{[domain]=""})
      local kT={key=devKey}
      abp.jfile("devkey", kT)
      return kT
   end
end

local function isreg()
   local http,wan,sockname=createHttp()
   if not http then return nil,wan,sockname end
   local kT=abp.jfile"devkey"
   if kT and kT.key then
      local hT={["X-Dev"]=kT.key}
      hT=http("IsRegistered",hT,true)
      if hT then
         return hT["X-Name"],kT.key,wan,sockname
      end
   end
   return false,wan,sockname
end

local function available(domain)
   local http,wan,sockname=createHttp()
   if not http then return nil,wan,sockname end
   local hT={["X-Name"]=domain}
   hT,status,err=http("IsAvailable", hT)
   if hT then
      return (hT["X-Available"] == "Yes" and true or false),wan,sockname
   end
   return nil,status,err
end


local function auto(email,domain,op)
   local http,wan,sockname=createHttp()
   if wan == sockname then
      return abp.setErr(fmt("Public IP address %s equals local IP address",wan))
   end
   if not http then return end
   local kT=abp.jfile"devkey"
   if kT and kT.key then
      local hT={["X-Dev"]=kT.key}
      if http("IsRegistered",hT,true) then
         hT["X-IpAddress"]=sockname
         hT=http("SetIpAddress",hT,true)
         if not hT then return end
         local regname=hT['X-Name']
         local curname = next(abp.jfile"domains" or {}) or ""
         if regname ~= curname then
            abp.jfile("domains",{[regname]=""})
         end
      else
         kT=register(http,sockname,domain,op.info)
      end
   else
      kT=register(http,sockname,domain,op.info)
   end
   if not kT then return end -- err
   -----
   local function set(dnsRecord, dnsAuth, rspCB)
      local hT={
         ["X-Dev"]=abp.jfile"devkey".key,
         ["X-RecordName"]=dnsRecord,
         ["X-RecordData"]=dnsAuth
      }
      local timer
      lock(rspCB, function() timer:cancel() end)
      if http("SetAcmeRecord",hT) then
         timer=ba.timer(function() lock() rspCB(true) end)
         timer:set(120000)
      else
         rspCB(false,"SetAcmeRecord failed")
      end
   end
   -----
   local function remove(rspCB)
      http("RemoveAcmeRecord",{["X-Dev"]=abp.jfile"devkey".key})
      rspCB(true)
   end
   -----
   op.ch={set=set,remove=remove}
   op.noDomCopy,op.cleanup=true,true
   op.shark=httpOptions.shark
   ab.configure(email,{next(abp.jfile"domains" or {})},op)
   abp.autoupdate(true)
end


function D.isreg(cb)
   checkCfg(3)
   local function action() cb(isreg()) end
   if type(cb) ~= "function" then
      local status,wan,sockname
      cb=function(st,w,sn) status,wan,sockname=st,w,sn end
      action()
      return status,wan,sockname
   end
   ba.thread.run(action)
end


function D.available(domain,cb)
   checkCfg(3)
   local function action() cb(available(domain)) end
   if type(cb) ~= "function" then
      local status,wan,sockname
      cb=function(st,w,sn) status,wan,sockname=st,w,sn end
      action()
      return status,wan,sockname
   end
   ba.thread.run(action)
end

function D.auto(email,domain,op)
   checkCfg(3)
   if type(op) ~= "table" or op.acceptterms ~= true then
      error("'acceptterms' not set",2)
   end
   manualMode,active=false,true
   abp.autoupdate(false)
   lock(nil,nil,true) -- release
   ba.thread.run(function() auto(email,domain,op) end)
   return true
end

function D.manual(email,domain,op)
   manualMode,active=true,true
   abp.autoupdate(false)
   lock(nil,nil,true) -- release
   op.ch={set=setManual,remove=function(rspCB) rspCB(true) end}
   op.shark=httpOptions.shark
   ab.configure(email,{domain},op)
   if op.auto then abp.autoupdate(true) end
   return true
end


function D.renew() checkM() return abp.renew() end
function D.active() return active and (manualMode and "manual" or "auto") end
function D.configure(key, url) return configure(key, url, 4) end

-- Called by .config if acme options
function D.cfgFileActivation()
   local aT,op=abp.getcfg()
   if aT.challenge.url ~= "manual" then
      configure(aT.challenge.key, aT.challenge.url)
      D.auto(aT.email,aT.domains[1],op)
   else
      op.auto=true
      D.manual(aT.email,aT.domains[1],op)
   end
end

function D.init(op,sm)
   if op then setHttpOptions(op) end
   if sm then
      assert(type(sm) == 'function', 'arg #2 must be func.')
      sendEmail=sm
   end
end

return D
