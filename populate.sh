#!/bin/bash

cp $1 ~/docker-volumes/probebuild_cacti-tmp/_data/

docker exec cacti /createdevices.sh $1
