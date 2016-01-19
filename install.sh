#!/bin/bash

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Configure user nobody to match unRAID's settings
export DEBIAN_FRONTEND="noninteractive"
usermod -u 99 nobody
usermod -g 100 nobody
usermod -d /home nobody
chown -R nobody:users /home

#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################
#config
cat <<'EOT' > /etc/my_init.d/config.sh
#!/bin/bash
if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
  DEBIAN_FRONTEND="noninteractive" dpkg-reconfigure -f noninteractive tzdata
fi
EOT

# hdhomerun
mkdir -p /etc/service/hdhomerun
cat <<'EOT' > /etc/service/hdhomerun/run
#!/bin/bash
umask 000
chown -R nobody:users /opt/hdhomerun
exec /sbin/setuser nobody /opt/hdhomerun/hdhomerun_record_x64 start
EOT

chmod -R +x /etc/service/ /etc/my_init.d/

#########################################
##             INSTALLATION            ##
#########################################
mkdir -p /opt/hdhomerun
wget --output-document=/opt/hdhomerun/hdhomerun_record_linux http://download.silicondust.com/hdhomerun/hdhomerun_record_linux
chmod +x /opt/hdhomerun/hdhomerun_record_linux
exec /opt/hdhomerun/hdhomerun_record_linux status
chmod +x /etc/service/hdhomerun_record/run

#########################################
##                 CLEANUP             ##
#########################################

# Clean APT install files
apt-get clean -y