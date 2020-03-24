
-- Read or write raw file or json file

local function file(io,name,data)
   local fp,ret,err
   if data then
      fp,err=io:open(name,"w")
      if fp then ret,err = fp:write(data) end
   else
      fp,err=io:open(name)
      if fp then ret=fp:read"*a" end
   end
   if fp then fp:close() end
   return ret,err
end

local function json(io,name,tab)
   if tab then
      return file(io,name,ba.json.encode(tab))
   end
   local ret,err=file(io,name)
   if ret then 
      ret=ba.json.decode(ret)
      if not ret then err="jsonerr" end
   end
   return ret,err
end

return {file=file,json=json}
