#! /bin/bash

testDir=$(realpath $(dirname $0))

cd $testDir/..
$MAKO_BIN -l::$testDir
