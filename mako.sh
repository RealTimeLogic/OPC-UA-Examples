#!/bin/bash

path=$(dirname $0)
LUA_CPATH=${path}/opcua-lua.git/opcua_ns0/?.so MAKO_ZIP=${path}/mako.zip ./mako -c ${path}/mako.conf.dev

