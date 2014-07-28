include:
  - ufw

ufw_service_disable:
  service.dead:
    - name: ufw
    - enable: True

ufw_disable:
  cmd.run:
    - name: "ufw --force disable"
    - prereq:
      - pkg: ufw



