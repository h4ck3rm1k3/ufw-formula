include:
  - ufw

extend:
  ufw:
    pkg:
      - purged

    service:
      - dead
      - enable: False

  ufw_enable:
    cmd.run:
      - name: "ufw --force disable"
      - onlyif: "which ufw"
      - require:
        - pkg: ufw



