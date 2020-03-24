local function loadcfg()
   local conf={}
   if _G.mako.cfgfname then
      local fp=ba.openio"disk":open(_G.mako.cfgfname)
      if fp then
         local f,e=load(fp:read"*a","","bt",conf)
         fp:close()
         if f then
            pcall(f)
         end
      end
   end
   return conf
end
local conf=loadcfg()
conf.load=loadcfg
return conf

