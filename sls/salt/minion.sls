include:
  - .minion-config
  - .selinux
{% if grains['os'] == 'Gentoo' %}
  - .pkg
{% if grains['os'] == 'Ubuntu' %}
  - .pkg-ubuntu-minion
{% if grains['os'] == 'Debian' %}
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
{% if grains['os'] == 'Ubuntu' %}
      - pkg: pkg_salt-minion
{% if grains['os'] == 'Debian' %}
      - pkg: pkg_salt-minion
{% endif %}


