#!/bin/bash

#yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

cat <<EOF >/etc/yum.repos.d/epel.repo
[epel]
name=Extra Packages for Enterprise Linux 7 - \$basearch
baseurl=http://mirror.grid.uchicago.edu/pub/linux/epel/7/\$basearch
#metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=\$basearch&infra=\$infra&content=\$contentdir
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
EOF

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
