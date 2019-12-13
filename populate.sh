#!/bin/bash

SMOKETARGETS=/docker/smokeping/config/Targets

cp $1 /docker/cacti/data/
chmod 600 /docker/cacti/data/$1

docker exec cacti /createdevices.sh $1

echo "*** Targets ***

probe = FPing

menu = Top
title = Network Latency Grapher
remark = Welcome to the SmokePing website of WORKS Company. \
         Here you will learn all about the latency of our network.

" > $SMOKETARGETS

while IFS="," read var1 var2 var3

do
DEVICENAME=$(echo $var1 | sed -r 's/(\W|_)//g')
echo "+ $DEVICENAME
menu = $var1
title = $var1 ($var2)
host = $var2
" >> $SMOKETARGETS
done <$1

docker restart smokeping
