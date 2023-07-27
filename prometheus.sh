#!/bin/bash

exec > prometheusinstallation.log 2>&1
uptime
date
#check internet is working or not
curl google.com

echo " Removing any exiting prometheus file "
rm -Rrf /tmp/prometheus-2.20.0.linux-amd64*

##downloading Prometheus binaries
echo " downloading Prometheus binaries >>>>>>>>>>>>>>>"
cd /tmp/ && wget https://github.com/prometheus/prometheus/releases/download/v2.20.0/prometheus-2.20.0.linux-amd64.tar.gz 

useradd --no-create-home -s /bin/false prometheus
mkdir /etc/prometheus
mkdir /var/lib/prometheus
chown prometheus:prometheus /etc/prometheus && chown prometheus:prometheus /var/lib/prometheus
chmod 775 /etc/prometheus

pwd

echo "verifying tar file is downloaded or not"
ls -lrt /tmp/prometheus-2.20.0.linux-amd64.tar.gz && chmod 775 /tmp/prometheus-2.20.0.linux-amd64.tar.gz

if [[ ! -f prometheus-2.20.0.linux-amd64.tar.gz ]] ; then
    echo 'File "prometheus tar file not downloaded" is not there, aborting.'
    exit
fi
#unziping  the file
tar -zxvf prometheus-2.20.0.linux-amd64.tar.gz

cd /tmp/prometheus-2.20.0.linux-amd64/
cp prometheus.yml /etc/prometheus/
cp prometheus /usr/local/bin
cp promtool /usr/local/bin

#optional step , 
firewall-cmd --add-port=9090/tcp --permanent
firewall-cmd --reload

cp -pr root/prometheus.service /etc/systemd/system/prometheus.service
systemctl start prometheus
systemctl status prometheus
