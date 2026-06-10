#!/bin/bash
set -euo pipefail

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

export DEBIAN_FRONTEND="noninteractive"

# Configure user nobody to match unRAID's settings
usermod -u 99 nobody
usermod -g 100 nobody
usermod -d /home nobody
chown -R nobody:users /home || true

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
chmod 666 /etc/hdhomerun.conf

# Ensure supervisor run directory exists
mkdir -p /var/run /var/log/supervisor

#########################################
##                 CLEANUP             ##
#########################################

apt-get clean -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*