#!/usr/bin/bash -e

# Enable Nginx stub status
# cat <<'EOF' | sudo tee /tmp/test
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

# Prepare the influxdb app
dokku apps:create influxdb
dokku proxy:disable influxdb
dokku docker-options:add influxdb deploy,run "-p 127.0.0.1:8086:8086"
dokku network:set influxdb attach-post-create dashboard
dokku config:set influxdb INFLUXDB_LOGGING_LEVEL=error
dokku git:from-image influxdb influxdb:1.8

# Prepare the telegraf app
dokku apps:create telegraf
dokku proxy:disable telegraf
dokku network:set telegraf initial-network host
dokku builder-dockerfile:set telegraf dockerfile-path telegraf.dockerfile
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

# Prepare the grafana app
dokku apps:create grafana
dokku proxy:ports-set grafana http:80:3000 https:443:3000
dokku network:set grafana attach-post-create dashboard
dokku builder-dockerfile:set grafana dockerfile-path grafana.dockerfile
dokku domains:add grafana dashboard.mywebsite.com
dokku letsencrypt:enable grafana
