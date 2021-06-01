# OPC-UA web client and OPC-UA server example

This directory includes both a client and server example. The two
examples are designed to run simultaneously. The client example
connects to the server example. The client example provides a basic
HTML view of the OPC-UA address space. You can navigate the address
space by clicking on the nodes with a plus (+) symbol.

You may also connect other (external) OPC-UA clients to the server
example. See FIXME for a tutorial on connecting various OPC-UA
clients.

This directory includes a mako.conf file that instructs the mako
server to load both examples. Simply start the Mako server in this
directory without providing any arguments and the Mako Server will
load both examples. The mako.conf file also shows how the Mako server
configuration file can be used for setting custom OPC-UA settings.
