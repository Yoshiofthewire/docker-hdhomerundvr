#!/bin/bash

# chfn workaround - Known issue within Dockers
ln -s -f /bin/true /usr/bin/chfn

apt-get -q update
apt-get install -qy gdebi-core wget

#download and install hdhomerun dvr engine
wget -q --output-document=/tmp/hdhomerun_record_linux http://download.silicondust.com/hdhomerun/hdhomerun_record_linux
cd /tmp
chmod +x /tmp/hdhomerun_record_linux
exec /tmp/hdhomerun_record_linux version  
exec /tmp/hdhomerun_record_linux status
mv /tmp/hdhomerun_record_x86 /usr/bin/hdhomerun_record_x86
chmod +x /usr/bin/hdhomerun_record_x86

# Add hdhomerun dvr to runit
mkdir -p /etc/service/hdhomerun_record
cat <<'EOT' > /etc/service/hdhomerun_record/run
#!/bin/bash
umask 000
# Fix permission if user is 999
if [ -d /hdhomerun ]; then
	if [ "$(stat -c "%u" /hdhomerun)" -eq "999" ]; then
		echo "Fixing HDHOMERUN Library permissions"
		chown -R 99:100 /hdhomerun
		chmod -R 777 /hdhomerun
	fi
fi
exec /usr/bin/hdhomerun_record_x86 start
EOT
chmod +x /etc/service/hdhomerun_record/run
