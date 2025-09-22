include:
  - nginx.service

{% set nginx = salt.pillar.get('nginx', {}) %}
{% if grains.os_family == 'Debian' %}
  {% set nginx_default_user = 'www-data' %}
{% else %}
  {% set nginx_default_user = 'nginx' %}
{% endif %}
{% set nginx_user = nginx.get('user', nginx_default_user) %}
{% set nginx_group = nginx.get('group', nginx_user) %}

/var/www/default/:
  file.directory:
    - create: True
    - mode: 755
    - user: {{ nginx_user }}
    - group: {{ nginx_user }}
    - require:
      - file: /var/www/

/var/www/default/html:
  file.directory:
    - create: True
    - mode: 755
    - user: {{ nginx_user }}
    - group: {{ nginx_user }}
    - require:
      - file: /var/www/default/

/var/www/default/errors:
  file.directory:
    - create: True
    - mode: 755
    - user: {{ nginx_user }}
    - group: {{ nginx_user }}
    - require:
      - file: /var/www/default/

/etc/nginx/vhosts.d/default.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/default.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/nginx/vhosts.d/
    - watch_in:
      - service: nginx-reload

