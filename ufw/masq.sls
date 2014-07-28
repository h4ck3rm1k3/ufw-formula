
# 
# https://help.ubuntu.com/10.04/serverguide/firewall.html

{#

TODO:

bridged_iface: eth1
internal_iface_and_mask: 10.10.0.0/24

#}

ufw_forwarding:
  file.replace:
    - name: /etc/default/ufw
    - pattern: 'DEFAULT_FORWARD_POLICY="DROP"'
    - repl: 'DEFAULT_FORWARD_POLICY="ACCEPT"'
    - require:
      - pkg: ufw


/etc/ufw/sysctl.conf:
  file.managed:
    - source: salt://ufw/templates/ufw-sysctl.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: ufw
    #- defaults:
    #  ufw:
    #    ipv4_forwarding: True
    #    ipv4_ignore_icmp_echo: False
    #    ipv6_enable: False
    #    ipv6_fowarding: [default, all]
    #    ipv6_autoconfiguration: [default, all]
    #    ipv6_use_tempaddr: [default, all]

  
/etc/ufw/before.rules:
  file.append:
    - text: |
        # NAT Table rules
        *nat
        :POSTROUTING ACCEPT [0:0]

        # Forward traffic from eth1 through eth0.
        -A POSTROUTING -s 10.10.0.0/24 -o eth1 -j MASQUERADE

        COMMIT
    - require:
      - pkg: ufw


ufw_restart:
  cmd.wait:
    #- name: sudo ufw disable && sudo ufw --force enable
    - name: sudo ufw --force reload
    - watch:
      - pkg: ufw
      - file: /etc/ufw/before.rules
      - file: /etc/ufw/sysctl.conf
      - file: /etc/default/ufw

