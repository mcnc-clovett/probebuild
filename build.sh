#!/bin/bash

#yum install -y epel-release
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

curl -fsSL https://get.docker.com/ | sh

systemctl start docker
systemctl enable docker

yum install -y tcpdump wireshark iperf iperf3 httpd

adduser iperf -s /sbin/nologin
cp ./systemd/* /etc/systemd/system/
systemctl daemon-reload
systemctl start iperf
systemctl start iperf3
systemctl enable iperf
systemctl enable iperf3

PROBEIP=`hostname -i` cat <<EOF >/var/www/html/index.html
<HTML>

<HEAD>
If the hyperlinks below do not work, go to address associated beneath.<br><br>
</HEAD>

<BODY>

<a href="#" onclick="javascript:window.location.port=8081">Smokeping</a><br>
http://$PROBEIP:8081/smokeping/sm.cgi<br><br>

<a href="#" onclick="javascript:window.location.port=8080">Cacti</a><br>
http://$PROBEIP:8080/cacti/<br><br>

<a href="#" onclick="javascript:window.location.port=3000">NTop</a><br>
http://$PROBEIP:3000

</BODY>

</HTML>
EOF

yum install -y docker-compose
docker-compose up -d

ln -s /var/lib/docker/volumes ~/docker-volumes

firewall-cmd --add-service=http --add-service=https
firewall-cmd --add-port=3000/tcp --add-port=3333/tcp --add-port=5001/tcp \
    --add-port=5001/udp --add-port=5201/tcp --add-port=5201/udp
firewall-cmd --runtime-to-permanent
