{% for packagefile in ['keywords','use'] %}
/etc/portage/package.{{ packagefile }}/SALT:
  file.managed:
    - source: salt://{{ tpldir }}/files/packages.tpl
    - mode: '0640'
    - user: root
    - group: portage
    - template: jinja
    - makedirs: True
    - defaults:
      packagefile: {{ packagefile }}
      packagespillar: {{ salt['pillar.get']('gentoo:portage:packages',{}) }}
{% endfor %}
