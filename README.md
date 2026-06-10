# docker-hdhomerundvr

Docker container for the [HDHomeRun DVR Server](https://forum.silicondust.com/forum/viewtopic.php?f=126&t=20613) by SiliconDust.

**HDHomeRun DVR Server version:** 20250815  
**Base image:** ubuntu:22.04

---

## Features

- Runs the HDHomeRun DVR recording engine inside a Docker container
- `supervisord` keeps the process alive — auto-restarts if the DVR daemon crashes
- Container-level `restart: unless-stopped` policy recovers from container failures
- Timezone configurable via the `TZ` environment variable
- Host networking for full HDHomeRun device discovery (UDP broadcast)

---

## Requirements

- A working HDHomeRun network tuner with up-to-date firmware (see below)
- Docker and Docker Compose installed on the host

---

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/Yoshiofthewire/docker-hdhomerundvr.git
cd docker-hdhomerundvr

# 2. Edit docker-compose.yml and set your recordings path and timezone
#    volumes:
#      - /your/recordings/path:/hdhomerun
#    environment:
#      - TZ=America/New_York

# 3. Build and start
docker compose up -d --build
```

---

## Configuration

| Environment Variable | Default | Description |
|---|---|---|
| `TZ` | `UTC` | Timezone (e.g. `America/New_York`, `Europe/London`) |

**Volumes**

| Container Path | Description |
|---|---|
| `/hdhomerun` | Recording output directory — map this to your storage path |

**Ports**

| Port | Protocol | Description |
|---|---|---|
| `65001` | UDP | HDHomeRun discovery |
| `65002` | TCP | DVR control/streaming |

> **Note:** `network_mode: host` is used in `docker-compose.yml` so that UDP broadcast device discovery works correctly. In host mode, the `ports` mapping is bypassed — the ports above are for documentation.

---

## Updating the HDHomeRun Firmware

Before the first install or when updating firmware:

1. Install the HDHomeRun Windows or Mac application.
2. When prompted to install the DVR server component, select **Don't Install**.
3. You will be prompted to configure the tuner after setup completes.
4. Re-run the tuner setup — this will update the firmware.
5. You may need to re-scan channels after the firmware update.

---


## How It Works

```
Docker container
└── supervisord (PID 1, nodaemon=true)
    └── hdhomerun_wrapper.sh
        ├── Calls: hdhomerun_record_x64 start  (starts DVR daemon)
        ├── Monitors: DVR process every 15 seconds
        └── On crash: exits non-zero → supervisord auto-restarts wrapper
```

- `supervisord` runs as PID 1 in the foreground (`nodaemon=true`), preventing spurious container exits.
- `hdhomerun_wrapper.sh` wraps the DVR daemon (which forks to the background) and stays alive to monitor it.
- If the DVR process disappears, the wrapper exits with a non-zero code so supervisord restarts it (up to 10 retries).
- `SIGTERM` from Docker is caught cleanly — the wrapper calls `hdhomerun_record_x64 stop` before exiting.

---

## License

GPL v2.0
