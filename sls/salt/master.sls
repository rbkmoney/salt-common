include:
  - .common
  - .repos
  - .selinux
  - .pkg
{% set g_init = grains.get("init", "openrc") %}
{% set limits = salt.pillar.get("salt:master:limits", {}) %}

salt-master:
  service.running:
    - enable: True
    - order: last
    - watch:
      - file: /etc/salt/master
      - file: /etc/salt/master.d/roots.conf
      - pkg: app-admin/salt

{% if g_init == "openrc" %}
/etc/conf.d/salt-master:
  file.managed:
    - source: salt://{{ slspath }}/files/salt-master.confd.tpl
    - template: jinja
    - defaults:
        salt_opts: {{ salt.pillar.get("salt:master:opts", "--log-level=warning") }}
        l_nofile: {{ limits.get("nofile", "1048576") }}
        l_nproc: {{ limits.get("nproc", "4096") }}
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: salt-master
{% endif %}

/etc/salt/master:
  file.serialize:
    - dataset_pillar: 'salt:master:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: 640
    - require:
      - file: /etc/salt/
      - pkg: app-admin/salt

/etc/salt/master.d/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /etc/salt/

extend:
  /etc/salt/master.d/roots.conf:
    file.managed:
      - require:
        - file: /etc/salt/master.d/
