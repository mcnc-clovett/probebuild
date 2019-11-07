#!/bin/bash

cp $1 ~/docker-volumes/probebuild_cacti-tmp/_data/

docker exec probebuild_cacti_1 /createdevices.sh $1
