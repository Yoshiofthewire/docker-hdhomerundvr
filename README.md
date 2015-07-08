This is a Dockerfile setup for hdhomerun dvr - https://www.silicondust.com/forum/viewforum.php?f=89

To run the latest plex version:

```
docker run -d --net="host" --name="hdhomerundvr" -v /path/to/recordings:/hdhomerun -v /etc/localtime:/etc/localtime:ro yoshiof/plex/hdhomerundvr
```

After install go to:

Your Kodi Client
