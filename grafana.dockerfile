FROM grafana/grafana:8.2.3

COPY grafana/data/dashboards/dokku-dash /var/lib/grafana/dashboards/dokku-dash
COPY grafana/config/provisioning /etc/grafana/provisioning
