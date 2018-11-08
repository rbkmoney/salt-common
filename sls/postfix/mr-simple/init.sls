include:
  - postfix.common
  - postfix.collectd
  - pypolicyd-spf
  - opendkim
  - syslog

extend:
  postfix:
    service:
      - watch:
        - pkg: mail-filter/pypolicyd-spf
      - require:
        - service: opendkim

/etc/postfix/main.cf:
  file.managed:
    - source: salt://postfix/mr-simple/main.cf.tpl
    - template: jinja
    - defaults:
    - context:
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: postfix

/etc/postfix/master.cf:
  file.managed:
    - source: salt://postfix/mr-simple/master.cf
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: postfix

/etc/postfix/cert.pem:
  file.managed:
    - source: salt://ssl/certificate-chain.tpl
    - template: jinja
    - defaults:
        cert_chain_key: 'postfix'
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: postfix

/etc/postfix/privkey.pem:
  file.managed:
    - source: salt://ssl/privkey.tpl
    - template: jinja
    - defaults:
        privkey_key: 'postfix'
    - mode: 600
    - user: root
    - group: root
    - watch_in:
      - service: postfix

/etc/postfix/mynetworks:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: postfix-reload
    - contents: |
        {% for network in salt['pillar.get']('postfix:mynetworks', ['::1/128 OK']) %}
        {{ network }}
        {% endfor %}
