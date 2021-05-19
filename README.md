## OPC-UA examples for [Real Time Logic's OPC-UA stack](https://realtimelogic.com/products/opc-ua/).


## OPC-UA examples

* [Server Examples](server/README.md)



## Nano Embedded Device Profile

The OPC-UA stack supports the [Nano Embedded Device Profile](https://reference.opcfoundation.org/v104/Core/docs/Part7/6.6.65/), which includes:

* Discovery services to identify to prospective clients what capabilities are supported by the Server
* Base attribute services to process read attribute and write attribute from the OPC UA client
* UA secure conversation to implement the basic secure conversation protocol but without signing or encrypting the messages
* UA TCP Transport to quickly and efficiently move messages in as few bytes as possible

Some functionality that is not found in Nano Profile includes:

* Encryption and signing of messages to implement end to end security
* Monitored items to identify variables for subscription services

