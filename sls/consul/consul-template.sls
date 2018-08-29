include:
  - consul

app-admin/consul-template:
  pkg.installed:
    - pkgs:
      - app-admin/consul-template: ">=0.18.0"
    - require:
      - portage_config: app-admin/consul-template
  portage_config.flags:
    - name: "<consul-template-0.19"
    - accept_keywords:
      - "~*"

/etc/conf.d/consul-template:
  file.managed:
    - source: salt://consul/files/consul-template/consul-template.confd.tpl
    - template: jinja
    - mode: 644
    - require:
      - pkg: app-admin/consul-template

/etc/init.d/consul-template:
  file.managed:
    - source: salt://consul/files/consul-template/consul-template.initd
    - template: jinja
    - mode: 755
    - require:
      - pkg: app-admin/consul-template

/etc/consul-template.d/consul.conf:
  file.managed:
    - source: salt://consul/files/consul-template/consul.conf.tpl
    - template: jinja
    - mode: 640
    - user: root
    - group: consul-template
    - require:
      - pkg: app-admin/consul-template

/etc/consul-template-templates/:
  file.directory:
    - create: true
    - mode: 755
    - user: consul-template
    - group: consul-template
    - require:
      - pkg: app-admin/consul-template

consul-template:
  service.running:
    - enable: True
    - watch:
      - pkg: app-admin/consul-template
      - file: /etc/conf.d/consul-template
      - file: /etc/init.d/consul-template
      - file: /etc/consul-template.d/consul.conf
      - file: /etc/consul-template-templates/
