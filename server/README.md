Server step-by-step guide:

1. How to set up an OPC-UA server in four lines of code.

2. How to configure the server.
   This example shows how to customize the server configuration,
   including listening port, network interface, endpoint URL, etc..

3. An introduction in how to browse OPC-UA nodes on the server side.
   The address space is represented by set of nodes with references
   between them. This example shows how to browse the nodes in the
   address space and how to print them using the
   [trace](https://realtimelogic.com/ba/doc/?url=lua.html#_G_trace)
   function.

4. An introduction in how to read attributes on the server side.
   Every node in the address space can include a set of attributes.
   The main attributes of node are: NodeID, BrowseName, Value, NodeClass, etc.

5. How to add your own nodes to the OPC-UA Address Space. An
   initialized server only includes the standard address space. An
   OPC-UA server typically requires additional nodes for representing
   a complex object such as machinery. This example shows how to add
   your own nodes with custom values.

6. How to update nodes in a running system.
   This example adds an int64 node to the address space, starts the
   server, and then increments the int64 node every second.

7. How to set up a read/write callback for variable node.
   This example sets callback for float variable node, starts the
   server, and then callback will be called on each read and write 
   requests from client.

