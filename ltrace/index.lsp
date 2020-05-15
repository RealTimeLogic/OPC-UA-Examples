<!DOCTYPE html>
<html lang="en">
<head>
<style>

th,td{
padding-left:5px;padding-right:5px;padding-top:0;padding-bottom:0;
padding:0 5px;
min-width:100px;
}


table{border-collapse:collapse;}
table,th,td{border:1px solid #969696;}
th {
  background: #969696 url(/rtl/wfm/bg.png) no-repeat;
  color:white;
  cursor:pointer;
  font-weight: bold;
  height:1.8em;
}
th.tablesorter-headerAsc {
  background: #969696 url(/rtl/wfm/asc.png) no-repeat;
}
th.tablesorter-headerDesc {
  background: #969696 url(/rtl/wfm/desc.png) no-repeat;
}
tr.odd  {
  padding-left:5px;padding-right:5px;padding-top:0;padding-bottom:0;
  background: #FFFFFF;
}
tr.even  {background: #efefef;}
</style>
<script src='/rtl/jquery.js'></script>
<script>
$(function() {
    $("table").tablesorter({
	sortList: window.sortList ? window.sortList : [[0,0]],
	widgets: ['zebra']
    });
});
</script>
</head>
<body>
<?lsp

local excludeTab={
   _emit=true,
   print=true,
   lspfilter=true,
   excludeTab=true,
   tracep=true,
   write=true,
}

local lt=require"ltrace"

response:write'<h2>Completed Calls</h2>'
response:write'<h3>Lua code:</h3>'

response:write'<table><thead><tr><th>Name</th><th>Clock</th><th>Count</th><th>Source</th></th></tr></thead><tbody>'
for _,t in ipairs(lt.get()) do
   if t.source ~= "=[C]" and not t.busy then
      response:write('<tr><td>',t.name,'</td><td>',t.clock,
                     '</td><td>',t.count,'</td><td>',
                     t.source,' : ',t.line,'</td></tr>')
   end
end
response:write'</tbody></table>'

response:write'<h3>C code:</h3>'
response:write'<table><thead><tr><th>Name</th><th>Clock</th><th>Count</th></tr></thead><tbody>'

for _,t in ipairs(lt.get()) do
   if t.source == "=[C]" and not t.busy and not excludeTab[t.name] then
      response:write('<tr><td>',t.name,'</td><td>',t.clock,
                     '</td><td>',t.count,'</td></tr>')
   end
end
response:write'</tbody></table>'


response:write'<h2>Active Calls</h2>'


response:write'<h3>Lua code:</h3>'

response:write'<table><thead><tr><th>Name</th><th>Count</th><th>Source</th></th></tr></thead><tbody>'
for _,t in ipairs(lt.get()) do
   if t.source ~= "=[C]" and t.busy then
      response:write('<tr><td>',t.name,'</td><td>',
                     t.count,'</td><td>',
                     t.source,' : ',t.line,'</td></tr>')
   end
end
response:write'</tbody></table>'

response:write'<h3>C code:</h3>'
response:write'<table><thead><tr><th>Name</th><th>Count</th></tr></thead><tbody>'

for _,t in ipairs(lt.get()) do
   if t.source == "=[C]" and t.busy and not excludeTab[t.name] then
      response:write('<tr><td>',t.name,'</td><td>',t.count,'</td></tr>')
   end
end
response:write'</tbody></table>'


?>
</body>
</hmtl>


