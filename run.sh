#!/bin/bash
export MOAI_BIN=./hosts/win32
export MOAI_CONFIG=./hosts/win32
export MOAI_SOURCE=./source
SOURCE=./source
./$MOAI_BIN/moai.exe $MOAI_CONFIG/config.lua $MOAI_SOURCE/main.lua
 
echo "string"