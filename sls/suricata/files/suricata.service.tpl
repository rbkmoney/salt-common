# Managed by Salt
[Unit]
Description=Suricata IDS/IDP daemon
After=network.target
Requires=network.target
Documentation=man:suricata(8) man:suricatasc(8)
Documentation=https://suricata.readthedocs.io/

[Service]
User={{ user }}
Group={{ group }}
AmbientCapabilities=CAP_NET_ADMIN
CapabilityBoundingSet=CAP_NET_ADMIN
NoNewPrivileges=yes
# ProtectSystem=strict
RuntimeDirectory=suricata
PIDFile=/run/suricata/suricata-%i.pid
ExecStart=/usr/bin/suricata -c /etc/suricata/suricata-%i.yaml --pidfile /run/suricata/suricata-%i.pid -D ${OPTS}
ExecReload=/bin/kill -HUP $MAINPID
ExecStop=/bin/kill $MAINPID
PrivateTmp=yes
ProtectHome=yes

[Install]
WantedBy=multi-user.target
