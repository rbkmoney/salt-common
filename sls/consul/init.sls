include:
  - .service
{% if grains['os'] == 'Gentoo' %}
  - .pkg
{% elif grains['os'] == 'Ubuntu' %}
  - .pkg-ubuntu
{% elif grains['os'] == 'Debian' %}
  - .pkg-debian
{% endif %}

extend:
  consul:
    service.running:
      - watch:
        - pkg: app-admin/consul
