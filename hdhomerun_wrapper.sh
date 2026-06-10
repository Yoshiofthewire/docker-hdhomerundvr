#!/bin/bash
# Wrapper script for hdhomerun_record_x64.
# Keeps supervisord satisfied by staying alive in the foreground
# while monitoring the hdhomerun daemon process.

set -eo pipefail

HDHOMERUN_BIN="/opt/hdhomerun/hdhomerun_record_x64"
CHECK_INTERVAL=15

# Clean shutdown handler — called on SIGTERM/SIGINT from supervisord
shutdown_handler() {
    echo "[wrapper] Received shutdown signal, stopping HDHomeRun DVR..."
    "$HDHOMERUN_BIN" stop 2>/dev/null || true
    exit 0
}

trap shutdown_handler SIGTERM SIGINT SIGQUIT

# Stop any previously running instance before starting fresh
echo "[wrapper] Stopping any existing HDHomeRun DVR instance..."
"$HDHOMERUN_BIN" stop 2>/dev/null || true
sleep 2

# Start the DVR daemon
echo "[wrapper] Starting HDHomeRun DVR..."
if ! "$HDHOMERUN_BIN" start; then
    echo "[wrapper] ERROR: hdhomerun_record_x64 failed to start (exit code: $?)" >&2
    exit 1
fi

# Allow the daemon time to fully initialize
sleep 3

echo "[wrapper] HDHomeRun DVR is running. Monitoring process..."

# Monitor loop — exit non-zero so supervisord auto-restarts this wrapper
while true; do
    if ! pgrep -f "hdhomerun_record" > /dev/null 2>&1; then
        echo "[wrapper] ERROR: HDHomeRun DVR process is no longer running. Triggering supervisord restart..." >&2
        exit 1
    fi
    # Use background sleep + wait so the trap fires promptly on signals
    sleep "$CHECK_INTERVAL" &
    wait $!
done
