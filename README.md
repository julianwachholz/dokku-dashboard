# Dokku Dashboard

A Grafana dashboard for your Dokku server.

## Installation

1. Run `prepare.sh` on the Dokku server
2. Add remote to deploy telegraf

   ```bash
   git remote add dokku-telegraf dokku@dokku-server:telegraf
   git push dokku-telegraf main
   ```

3. Add remote to deploy grafana

   ```bash
   git remote add dokku-grafana dokku@dokku-server:grafana
   git push dokku-grafana main
   ```
