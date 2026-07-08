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
##      RUN AND SUPERVISE THE DVR      ##
#########################################

WRAPPER="/opt/hdhomerun/hdhomerun_wrapper.sh"
MAX_RETRIES=10
child_pid=""

forward_signal() {
    echo "[entrypoint] Received shutdown signal, stopping HDHomeRun DVR wrapper..."
    if [ -n "$child_pid" ]; then
        kill -TERM "$child_pid" 2>/dev/null || true
        wait "$child_pid" 2>/dev/null || true
    fi
    exit 0
}
trap forward_signal SIGTERM SIGINT SIGQUIT

retries=0
while true; do
    setpriv --reuid=hdhomerun --regid=hdhomerun --init-groups "$WRAPPER" &
    child_pid=$!
    status=0
    wait "$child_pid" || status=$?

    if [ "$status" -eq 0 ]; then
        echo "[entrypoint] HDHomeRun DVR wrapper exited cleanly."
        exit 0
    fi

    retries=$((retries + 1))
    if [ "$retries" -ge "$MAX_RETRIES" ]; then
        echo "[entrypoint] ERROR: wrapper failed ${MAX_RETRIES} times, giving up." >&2
        exit 1
    fi
    echo "[entrypoint] Wrapper exited with status ${status}, restarting (attempt ${retries}/${MAX_RETRIES})..."
done
