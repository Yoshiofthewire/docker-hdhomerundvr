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
apt-get install -qy supervisor tzdata procps

#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################

chmod +x /opt/hdhomerun/hdhomerun_record_x64
chmod +x /opt/hdhomerun/hdhomerun_wrapper.sh
chmod +x /entrypoint.sh
chmod 644 /etc/hdhomerun.conf

# Ensure supervisor run directory exists
mkdir -p /var/run /var/log/supervisor
chown -R hdhomerun:hdhomerun /opt/hdhomerun /hdhomerun /var/log/supervisor

#########################################
##                 CLEANUP             ##
#########################################

apt-get clean -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*