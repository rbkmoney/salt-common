include:
  - .minion-config
  - .selinux
{% if grains['os'] == 'Gentoo' %}
  - .pkg
{% elif grains['os'] == 'Ubuntu' %}
  - .pkg-ubuntu-minion
{% elif grains['os'] == 'Debian' %}
  - .pkg-debian-minion
{% endif %}

salt-minion:
  service.running:
    - enable: True
    - order: last
    - watch:
      - file: /etc/salt/minion
{% if grains['os'] == 'Gentoo' %}
      - pkg: app-admin/salt
{% elif grains['os'] == 'Ubuntu' %}
      - pkg: pkg_salt-minion
{% elif grains['os'] == 'Debian' %}
      - pkg: pkg_salt-minion
{% endif %}


