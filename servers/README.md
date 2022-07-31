# Learn how to build OPC-UA Servers; a step-by-step guide.

We recommend starting with example one, which is started as follows:

```console
mako -l::start
```

See the
[Mako Server command line video tutorial](https://youtu.be/vwQ52ZC5RRg)
for more information on how to start the Mako Server.

1. "start": How to set up an OPC-UA server in four lines of code.

2. "server_config": How to configure the server.  This example shows
   how to customize the server configuration, including listening
   port, network interface, endpoint URL, etc..

3. "browse": An introduction in how to browse OPC-UA nodes on the
   server side.  The address space is represented by a set of nodes
   with references between them. This example shows how to browse the
   nodes in the address space and how to print them using the
   [trace](https://realtimelogic.com/ba/doc/?url=lua.html#_G_trace)
   function.

4. "read_data": An introduction in how to read attributes on the
   server side. Every node in the address space can include a set of
   attributes. A node's main attributes are: NodeID, BrowseName,
   Value, NodeClass, etc.

5. "add_nodes": How to add your own nodes to the OPC-UA Address
   Space. An initialized server only includes the standard address
   space. An OPC-UA server typically requires additional nodes for
   representing a complex object such as machinery. This example shows
   how to add your own nodes with custom values.

6. "write_data": How to update nodes in a running system.  This
   example adds an int64 node to the address space, starts the server,
   and then increments the int64 node every second.

7. "data_source": How to set up a read/write callback for a variable
   node. This example sets a callback for a float variable node and starts
   the server. The callback will be called for each read and write
   requests from the client.

8. "embed_web_server": A web application that provides interface to OPC-UA server.
   This example shows how to call server methods directly without network 
   interaction. Server instance is created at application start and then 
   LSP page calls its methods.
