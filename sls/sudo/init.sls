include:
  - .sudoers
{% if grains.os == 'Gentoo' %}
  - .pkg
{% elif grains.os == 'Ubuntu' or grains.os == 'Debian'%}
  - .pkg-debian
{% endif %}
