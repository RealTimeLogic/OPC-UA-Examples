
-- A few useful SQL functions

local type,unpack,fmt=
   type,table.unpack,string.format
local sqlite = luasql.sqlite
local dio=ba.openio"disk"
local _G=_G

local _ENV={}

local dbdir
local dos2unix

local function n2dbn(name)
   if not dbdir then _G.error("No DB base dir",3) end
   return fmt("%s%s%s",dbdir,name,".sqlite.db")
end

local function close(env,conn)
   conn:close()
   env:close()
end


local function select(conn,sql,func)
   local env
   if type(conn) == "function" then env,conn = conn() end
   local cur,err,err2=conn:execute('SELECT '..sql)
   if cur then
      local t={func(cur)}
      cur:close()
      if env then close(env, conn) end
      return unpack(t)
   end
   if env then close(env, conn) end
   if err2 then err=fmt("%s: %s",err,err2) end
   return nil,err
end

local function find(cur) return cur:fetch() end
function _ENV.find(conn,sql) return select(conn,sql,find) end
function _ENV.findt(conn,sql,t)
   local function find(cur) return cur:fetch(t,"a") end
   return select(conn,sql,find)
end

function dir(n)
   if not n then return dbdir end
   n=dos2unix(n)
   local st=dio:stat(n)
   if st and st.isdir then
      dbdir=(n.."/"):gsub("//","/")
   else
      _G.error(fmt("%s %s", n, st and "not a dir" or "not found"), 2)
   end
end

function exist(name)
   return dio:stat(n2dbn(name)) and true or false
end

function open(name, options)
   local conn
   name=dio:realpath(n2dbn(name))
   local env,err = sqlite()
   if env then
      conn, err = env:connect(name, options)
      if conn then return env,conn end
      env:close()
   end
   _G.error(fmt("Cannot open %s: %s",name,err),2)
end

local function init()
   local winT={windows=true,wince=true}
   local _,os=dio:resourcetype()
   if winT[os] then
      dos2unix=function(s)
         if not s then return "/" end
         if _G.string.find(s,"^(%w)(:)") then
            s=_G.string.gsub(s,"^(%w)(:)", "%1",1)
         end
         return _G.string.gsub(s,"\\", "/")
      end
   else
      dos2unix=function(x) return x end
   end
   local function mkdbdir(dir)
      if dir then
         dir=dos2unix(dir.."/data"):gsub("//","/")
         if dio:stat(dir) or dio:mkdir(dir) then return dir end
      end
   end
   dir(mkdbdir(_G.require"loadconf".dbdir) or mkdbdir(_G.mako.cfgdir) or
       mkdbdir(_G.ba.openio"home":realpath"") or mkdbdir(_G.mako.execpath))
end
init()

_ENV.close=close
_ENV.select=select
return _ENV
