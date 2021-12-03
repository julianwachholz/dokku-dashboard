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

4. Go to your Grafana site and setup your admin account.
   The default username and password is "admin".

5. Expose the Grafana interface with a domain:

   ```bash
   dokku domains:add grafana dashboard.mywebsite.com
   dokku letsencrypt:enable grafana
   ```

6. `dokku proxy:build-config grafana`
