include:
  - .repos
  - .selinux
{% if grains.os == 'Gentoo' %}
  - .pkg
{% elif grains.os_family == 'Debian' %}
  - .pkg-debian-master
{% endif %}

salt-master:
  service.running:
    - enable: True
    - order: last
    - watch:
      - file: /etc/salt/master
      - file: /etc/salt/master.d/roots.conf
{% if grains.os == 'Gentoo' %}
      - pkg: app-admin/salt
{% elif grains.os_family == 'Debian' %}
      - pkg: pkg_salt-master
{% endif %}


/etc/salt/master:
  file.serialize:
    - require:
      - pkg: app-admin/salt
    - dataset_pillar: 'salt:master:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: 640
