#!/usr/bin/bash -e

# Create a network for the services
dokku network:create dashboard

# Prepare the influxdb app
dokku apps:create influxdb
dokku proxy:disable influxdb
dokku network:set influxdb initial-network monitoring
dokku config:set influxdb INFLUXDB_LOGGING_LEVEL=error
dokku git:from-image influxdb influxdb:1.8

# Prepare the telegraf app
dokku apps:create telegraf
dokku proxy:disable telegraf
dokku network:set influxdb initial-network monitoring
dokku builder-dockerfile:set telegraf dockerfile-path telegraf.dockerfile
dokku docker-options:add telegraf run "--ipc=host" "--privileged" \
  "-v /var/run/docker.sock:/var/run/docker.sock:ro" \
  "-v /:/hostfs:ro" \
  "-v /etc:/hostfs/etc:ro" \
  "-v /proc:/hostfs/proc:ro" \
  "-v /sys:/hostfs/sys:ro" \
  "-v /var:/hostfs/var:ro" \
  "-v /run:/hostfs/run:ro" \
  "-e HOST_ETC=/hostfs/etc" \
  "-e HOST_PROC=/hostfs/proc" \
  "-e HOST_SYS=/hostfs/sys" \
  "-e HOST_VAR=/hostfs/var" \
  "-e HOST_RUN=/hostfs/run" \
  "-e HOST_MOUNT_PREFIX=/hostfs"

# Prepare the grafana app
dokku apps:create grafana
dokku network:set grafana initial-network monitoring
dokku builder-dockerfile:set grafana dockerfile-path grafana.dockerfile
