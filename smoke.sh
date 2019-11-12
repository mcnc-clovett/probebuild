#!/bin/bash

SMOKETARGETS=/docker/smokeping/config/Targets

echo "*** Targets ***

probe = FPing

menu = Top
title = Network Latency Grapher
remark = Welcome to the SmokePing website of WORKS Company. \
         Here you will learn all about the latency of our network.

" > $SMOKETARGETS

while IFS="," read var1 var2 var3

do
DEVICENAME=$(echo $var1 | sed 's/ //g')
echo "+ $DEVICENAME
menu = $var1
title = $var1 ($var2)
host = $var2
" >> $SMOKETARGETS
done <$1
