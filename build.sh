#!/bin/bash

yum install -y epel-release

curl -fsSL https://get.docker.com/ | sh

systemctl start docker
systemctl enable docker

yum install -y docker-compose tcpdump iperf iperf3

docker-compose up -d
