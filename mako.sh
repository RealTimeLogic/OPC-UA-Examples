#!/bin/bash

path=$(dirname $0)
LUA_CPATH="${BAROOT}/src/opcua/opcua_ns0/?.so;${path}/?.so" MAKO_ZIP=${BAROOT}/examples/MakoServer/obj/release/mako.zip ${BAROOT}/examples/MakoServer/obj/release/mako -c ${path}/mako.conf.dev

