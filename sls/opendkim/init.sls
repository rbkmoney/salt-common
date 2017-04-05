include:
  - opendkim.pkg

{% set conf = salt['pillar.get']('opendkim:conf') %}

opendkim:
  service.running:
    - enabled: True
    - watch:
      - file: /etc/opendkim/opendkim.conf
      - file: /etc/opendkim/signingtable
      - file: /etc/opendkim/keytable
      - file: /etc/opendkim/internalhosts
      - file: /etc/opendkim/externalignorelist

/etc/opendkim/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/opendkim/opendkim.conf:
  file.managed:
    - source: salt://opendkim/opendkim.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/opendkim/

/etc/opendkim/signing-table:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/opendkim/
    - contents: |
        # Managed by Salt
        {% for data in conf['signing-table'] %}
        {{ data['pattern'] }} {{ data['key-id'] }}
        {% endfor %}

/etc/opendkim/key-table:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/opendkim/
    - contents: |
        # Managed by Salt
        {% for key,data in conf['key-table'].items() %}
        {{ key }} {{ data.get('domain', '%') }}:{{ data['selector'] }}:/etc/opendkim/{{ key }}.pem
        {% endfor %}

/etc/opendkim/internal-hosts:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/opendkim/
    - contents:
        # Managed by Salt
        {% for cidr in conf['internal-hosts'] %}
        {{ cidr }}
        {% endfor %}

/etc/opendkim/external-ignore-list:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/opendkim/
    - contents:
        # Managed by Salt
        {% for cidr in conf['external-ignore-list'] %}
        {{ cidr }}
        {% endfor %}

{% for key in conf['key-table'].keys() %}
/etc/opendkim/{{ key }}.pem:
  file.managed:
    - mode: 600
    - user: milter
    - group: milter
    - contents_pillar: pki:dkim:keys:{{ key }}:contents
    - require:
      - file: /etc/opendkim/
    - watch_in:
      - service: opendkim
{% endfor %}
