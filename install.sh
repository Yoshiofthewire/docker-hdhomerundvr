#!/bin/bash
set -euo pipefail

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

export DEBIAN_FRONTEND="noninteractive"

# Create a dedicated runtime user for DVR processes
groupadd -r hdhomerun
useradd -r -g hdhomerun -d /home/hdhomerun -s /usr/sbin/nologin hdhomerun
mkdir -p /home/hdhomerun
chown -R hdhomerun:hdhomerun /home/hdhomerun

#########################################
##             INSTALLATION            ##
#########################################

apt-get -q update
apt-get install -qy tzdata procps

#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################

chmod +x /opt/hdhomerun/hdhomerun_record_x64
chmod +x /opt/hdhomerun/hdhomerun_wrapper.sh
chmod +x /entrypoint.sh
chown hdhomerun:hdhomerun /etc/hdhomerun.conf
chmod 644 /etc/hdhomerun.conf

chown -R hdhomerun:hdhomerun /opt/hdhomerun /hdhomerun

#########################################
##                 CLEANUP             ##
#########################################

apt-get clean -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*