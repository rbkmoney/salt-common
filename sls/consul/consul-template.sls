{% import 'pkg/common' as pkg %}
include:
  - consul
  - gentoo.portage.packages

app-admin/consul-template:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-admin/consul-template') }}
    - require:
      - file: gentoo.portage.packages

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
