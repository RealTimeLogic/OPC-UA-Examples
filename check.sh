#! /bin/bash

testDir=$(realpath $(dirname $0))

cd $testDir/..
$BAROOT/examples/MakoServer/obj/release/mako -l::$testDir
