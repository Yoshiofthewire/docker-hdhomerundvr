#!/bin/bash
set -e

#########################################
##        TIMEZONE CONFIGURATION       ##
#########################################

if [ -n "${TZ:-}" ]; then
    current_tz="$(cat /etc/timezone 2>/dev/null || true)"
    if [ "$current_tz" != "$TZ" ]; then
        echo "[entrypoint] Setting timezone to ${TZ}..."
        echo "$TZ" > /etc/timezone
        ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
        DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive tzdata 2>/dev/null || true
    fi
fi

#########################################
##        ENSURE VOLUME IS READY       ##
#########################################

mkdir -p /hdhomerun
chmod 755 /hdhomerun
chown hdhomerun:hdhomerun /hdhomerun || true

#########################################
##          START SUPERVISORD          ##
#########################################

echo "[entrypoint] Starting supervisord..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
