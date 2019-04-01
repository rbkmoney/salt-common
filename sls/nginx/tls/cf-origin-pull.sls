include:
  - nginx.service

/etc/ssl/nginx/cf-origin-pull/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/ssl/nginx/cf-origin-pull/origin-pull-ca.pem:
  file.managed:
    - source: salt://nginx/files/cf-origin-pull/origin-pull-ca.pem
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/ssl/nginx/cf-origin-pull/
    - watch_in:
      - service: nginx
