# disk_space_exporter
Does nothing but collects disk space over time for alerting

# Dependencies (needs >= Ubuntu 20.10)
`sudo apt install perl libprometheus-tiny-perl libplack-perl`

# Usage
`./app.psgi` - shebang calls `plackup` - change port with --port, see systemd service for example
# Docker
Since most things aren't on Ubuntu 20.10 yet, you can use the docker container:
`docker run --privileged --name disk-space-exporter --restart unless-stopped -it -d -p 5000:5000 jrcichra/disk-space-exporter`