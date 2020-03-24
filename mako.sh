#!/bin/bash

path=$(dirname $0)
MAKO_ZIP=${path}/mako.zip ./mako -lopcua::${path}/uaserver

