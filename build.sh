#!/bin/bash

yum install -y epel-release

curl -fsSL https://get.docker.com/ | sh

systemctl start docker
systemctl enable docker

yum install -y iperf iperf3

adduser iperf -s /sbin/nologin
cp ./systemd/* /etc/systemd/system/
systemctl daemon-reload
systemctl start iperf
systemctl start iperf3
systemctl enable iperf
systemctl enable iperf3

yum install -y tcpdump wireshark

yum install -y docker-compose
docker-compose up -d
