FROM telegraf:1.20

COPY telegraf/telegraf.conf /etc/telegraf/telegraf.conf

  # telegraf:
  #   image: telegraf:1.20.3
  #   privileged: true
  #   ipc: host
  #   volumes:
  #     - /var/run/docker.sock:/var/run/docker.sock:ro
  #     - /:/hostfs:ro
  #     - /etc:/hostfs/etc:ro
  #     - /proc:/hostfs/proc:ro
  #     - /sys:/hostfs/sys:ro
  #     - /var:/hostfs/var:ro
  #     - /run:/hostfs/run:ro
  #   environment:
  #     HOST_ETC: "/hostfs/etc"
  #     HOST_PROC: "/hostfs/proc"
  #     HOST_SYS: "/hostfs/sys"
  #     HOST_VAR: "/hostfs/var"
  #     HOST_RUN: "/hostfs/run"
  #     HOST_MOUNT_PREFIX: "/hostfs"
