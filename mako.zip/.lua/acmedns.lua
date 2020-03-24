
local domain,key
local ab=require"acmebot"
local abp=ab.pdns -- Import private funcs
local fmt=string.format

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
      if mako.daemon then
         local op={flush=true}
         mako.log(nil, op)
         op.subject="Set ACME DNS TXT Record"
         mako.log(msg, op)
      end
   else -- release
      -- call chain D.recordset() -> setManual OR
      -- D.get -> lock -> savedCleanupOnErrCB=setManual
      D.status,D.recordset=noActivation,noActivation
   end
end


-- activateAuto code below

local function createHttp(url)
   local op=ab.getproxy{shark=mako.sharkclient()}
   local http=require"http".create(op)
   local function xhttp(command,hT,nolog)
      local hT=hT or {}
      hT['X-Command'],hT['X-Key']=command,key
      local ok,err=http:request{
         trusted=true,
         url=url,
         method="GET",
         size=0,
         header=hT
      }
      if not ok then
	 abp.setErr(fmt("%s Err: %s\nURL: %s",op.proxy and "Proxy" or "HTTP",err,url))
      end
      hT = http:header()
      local status = http:status()
      if status ~= 201 then
         if not nolog and status and hT then
            abp.setErr(fmt("HTTP Status=%d: %s\nURL: %s",status,hT["X-Reason"], url))
         end
         return nil, status
      end
      return hT
   end
   local hT=xhttp"GetWan"
   if hT then
      return xhttp, hT['X-IpAddress'], http:sockname()
   end
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


local function auto(email,domain,op)
   local url = op.url or "https://acme.realtimelogic.com/command.lsp"
   local http,wan,sockname=createHttp(url)
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
   ab.configure(email,{next(abp.jfile"domains")},op)
   abp.autoupdate(true)
end

function D.auto(email,domain,k,op)
   key=k
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
   ab.configure(email,{domain},op)
   if op.auto then abp.autoupdate(true) end
   return true
end


function D.renew() checkM() return abp.renew() end
function D.active() return active and (manualMode and "manual" or "auto") end


-- Called by .config if acme options
function D.cfgFileActivation()
   local aT,op=abp.getcfg()
   if aT.challenge.url ~= "manual" then
      assert(type(aT.challenge.key) == 'string',"acme: Invalid key")
      D.auto(aT.email,aT.domains[1],aT.challenge.key,op)
   else
      op.auto=true
      D.manual(aT.email,aT.domains[1],op)
   end
end


return D
