#!/bin/bash

# Add Zscaler SSL certificate for those using SSL decryption
cp ./ZscalerRootCertificate-2048-SHA256.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust

# Set the Laptop Lid Switch handle to ignore so that the probe stays awake
sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf

# Install EPEL for CentOS
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install docker using official install script
curl -fsSL https://get.docker.com/ | sh

# Install other supporting applications
yum install -y tcpdump wireshark iperf iperf3 httpd cockpit cockpit-docker docker-compose

# Allow access to probe tools through the local firewall
firewall-cmd --add-service=http --add-service=https --add-service=cockpit
firewall-cmd --add-port=3000/tcp --add-port=3001/tcp --add-port=5001/tcp \
    --add-port=5001/udp --add-port=5201/tcp --add-port=5201/udp
firewall-cmd --runtime-to-permanent

# Add iperf service files and enable/start all services
adduser iperf -s /sbin/nologin
cp ./systemd/* /etc/systemd/system/
systemctl start httpd
systemctl enable httpd
systemctl start docker
systemctl enable docker
systemctl start cockpit
systemctl enable cockpit
systemctl daemon-reload
systemctl start iperf
systemctl start iperf3
systemctl enable iperf
systemctl enable iperf3

# Create homepage for web-based tools

cat <<EOF >/var/www/html/index.html
<HTML>

<HEAD>
If the hyperlinks below do not work, go to address associated beneath.<br><br>
</HEAD>

<BODY>

<a href="#" onclick="javascript:window.location.port=8081">Smokeping</a><br>
http://&lt;PROBEIP&gt;:8081<br><br>

<a href="#" onclick="javascript:window.location.port=8080">Cacti</a><br>
https://&lt;PROBEIP&gt;<br><br>

<a href="#" onclick="javascript:window.location.port=3000">NTop</a><br>
https://&lt;PROBEIP&gt;:3001<br><br>

<a href="#" onclick="javascript:window.location.port=9090">Cockpit</a><br>
https://&lt;PROBEIP&gt;:9090

</BODY>

</HTML>
EOF

# Download and start docker containers
docker-compose up -d
