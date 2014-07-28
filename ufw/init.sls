ufw:
  pkg:
    - installed

ufw_enable:
  cmd.run:
    - name: "ufw --force enable"
    - prereq:
      - pkg: ufw


{% if pillar.get('ufw', {}).get('ignore_icmp') %}
/etc/ufw/sysctl.conf-ipv4_icmp_echo_ignore_all:
  file.replace:
    - name: "/etc/ufw/sysctl.conf"
    - pattern: "#net/ipv4/icmp_echo_ignore_all=1"
    - repl: "net/ipv4/icmp_echo_ignore_all=1"
    - append_if_not_found: True
{% endif %}
