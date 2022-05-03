include:
  - .minion-config
  - .selinux
{% if grains.os == 'Gentoo' %}
  - .pkg
{% elif grains.os_family == 'Debian' %}
  - .pkg-debian-minion
{% endif %}

salt-minion:
  service.running:
    - enable: True
    - order: last
    - watch:
      - file: /etc/salt/minion
{% if grains.os == 'Gentoo' %}
      - pkg: app-admin/salt
{% elif grains.os_family == 'Debian' %}
      - pkg: pkg_salt-minion
{% endif %}


