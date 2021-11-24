#!/usr/bin/bash -e

# Enable nginx stub status
cat <<'EOF' | sudo tee /etc/nginx/conf.d/stub_status.conf
server {
  server_name localhost;
  location = /stub_status {
    stub_status;
  }
}
EOF
sudo service nginx reload

# Create a network for the services
dokku network:create dashboard


# InfluxDB
#
# Create influxdb dokku app
dokku apps:create influxdb
dokku network:set influxdb attach-post-create dashboard
# Persistent storage
dokku storage:ensure-directory influx-data
dokku storage:mount influxdb /var/lib/dokku/data/storage/influx-data:/var/lib/influxdb
# Listen only on localhost:8086
dokku proxy:ports-add influxdb http:8086:8086
dokku nginx:set influxdb bind-address-ipv4 127.0.0.1
# Reduce logging
dokku config:set influxdb INFLUXDB_LOGGING_LEVEL=error
# Deploy from Docker Hub image
dokku git:from-image influxdb influxdb:1.8


# Telegraf
#
# Prepare the telegraf dokku app
dokku apps:create telegraf
# Telegraf needs "host" network access for statistics
dokku network:set telegraf initial-network host
dokku proxy:disable telegraf
# Mount host system as readonly via docker-options
dokku docker-options:add telegraf deploy,run "--privileged" \
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
# Deploy from dockerfile
dokku builder-dockerfile:set telegraf dockerfile-path telegraf.dockerfile


# Grafana
#
# Prepare the grafana dokku app
dokku apps:create grafana
dokku network:set grafana attach-post-create dashboard
dokku proxy:ports-set grafana http:80:3000 https:443:3000
# Persistent storage
dokku storage:ensure-directory grafana-data
dokku storage:mount influxdb /var/lib/dokku/data/storage/grafana-data:/var/lib/grafana
# Deploy from dockerfile
dokku builder-dockerfile:set grafana dockerfile-path grafana.dockerfile
