#!/bin/bash

path=$(dirname $0)
MAKO_ZIP=${BAROOT}/examples/MakoServer/obj/release/mako.zip ${BAROOT}/examples/MakoServer/obj/release/mako -c ${path}/mako.conf.dev

