#!/bin/bash

exec > prometheusinstallation.log 2>&1
uptime
date
#check internet is working or not
curl google.com

echo " Removing any exiting prometheus file "
sudo rm -Rrf /tmp/prometheus-2.20.0.linux-amd64*
sudo rm -Rrf /etc/prometheus
sudo rm -Rrf /var/lib/prometheus

##downloading Prometheus binaries
echo " downloading Prometheus binaries >>>>>>>>>>>>>>>"
cd /tmp/ && wget https://github.com/prometheus/prometheus/releases/download/v2.20.0/prometheus-2.20.0.linux-amd64.tar.gz 

useradd --no-create-home -s /bin/false prometheus
sudo mkdir -p /etc/prometheus/consoles
sudo mkdir /etc/prometheus/console_libraries
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus && chown prometheus:prometheus /var/lib/prometheus
sudo chmod 775 /etc/prometheus

pwd

echo "verifying tar file is downloaded or not"
ls -lrt /tmp/prometheus-2.20.0.linux-amd64.tar.gz && chmod 775 /tmp/prometheus-2.20.0.linux-amd64.tar.gz

if [[ ! -f prometheus-2.20.0.linux-amd64.tar.gz ]] ; then
    echo 'File "prometheus tar file not downloaded" is not there, aborting.'
    exit
fi
#unziping  the file
tar -zxvf prometheus-2.20.0.linux-amd64.tar.gz

sudo cd /tmp/prometheus-2.20.0.linux-amd64/
sudo cp /tmp/prometheus-2.20.0.linux-amd64/prometheus.yml /etc/prometheus/
sudo cp /tmp/prometheus-2.20.0.linux-amd64/prometheus /usr/local/bin
sudo cp /tmp/prometheus-2.20.0.linux-amd64/promtool /usr/local/bin

#optional step , 
sudo firewall-cmd --add-port=9090/tcp --permanent
sudo firewall-cmd --reload

#copy prometheus executables to prom folder 
sudo cp -pr /home/$USER/prometheus.service /etc/systemd/system/prometheus.service

#starting prometheus
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl status prometheus
exit 0
