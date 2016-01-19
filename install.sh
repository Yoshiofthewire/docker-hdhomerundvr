#!/bin/bash

# chfn workaround - Known issue within Dockers
ln -s -f /bin/true /usr/bin/chfn

apt-get -q update
apt-get install -qy gdebi-core wget

#download and install hdhomerun dvr engine
wget --output-document=/tmp/hdhomerun_record_linux http://download.silicondust.com/hdhomerun/hdhomerun_record_linux
chmod +x /tmp/hdhomerun_record_linux
exec /tmp/hdhomerun_record_linux status
chmod +x /etc/service/hdhomerun_record/run
