#!/bin/bash

path=$(dirname $0)
MAKO_ZIP=${path}/mako_zip ./mako -c ${path}/mako.conf.dev

