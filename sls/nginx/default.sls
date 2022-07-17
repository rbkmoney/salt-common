include:
  - nginx.service

/var/www/default/:
  file.directory:
    - create: True
    - mode: 755
    - user: nginx
    - group: nginx

/var/www/default/html:
  file.directory:
    - create: True
    - mode: 755
    - user: nginx
    - group: nginx
    - require:
      - file: /var/www/default/

/var/www/default/errors:
  file.directory:
    - create: True
    - mode: 755
    - user: nginx
    - group: nginx
    - require:
      - file: /var/www/default/

/etc/nginx/vhosts.d/default.conf:
  file.managed:
    - source: salt://nginx/files/default.conf.tpl
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/nginx/vhosts.d/
    - watch_in:
      - service: nginx-reload

