FROM grafana/grafana:8.2.5

COPY grafana/dashboards/dokku-dash /etc/dashboards/dokku-dash
COPY grafana/provisioning /etc/grafana/provisioning
