FROM grafana/grafana:latest

COPY grafana/dashboards/dokku-dash /etc/dashboards/dokku-dash
COPY grafana/provisioning /etc/grafana/provisioning
