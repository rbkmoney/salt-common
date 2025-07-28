include:
  - logrotate
  - .pkg
  - .service

extend:
  nginx:
    service.running:
      - watch:
        - pkg: www-servers/nginx
  nginx-reload:
    service.running:
      - require:
        - pkg: www-servers/nginx


/etc/logrotate.d/nginx:
  file.managed:
    - source: salt://nginx/files/nginx.logrotate
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/logrotate.d/

{% if grains["os"] == "Gentoo" %}
{% set headers_more_m = "/usr/lib64/nginx/modules/ngx_http_headers_more_filter_module.so" %}
{{ headers_more_m }}:
  file.managed:
    - replace: False
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: www-servers/nginx

/etc/nginx/main.d/headers_more.conf:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - contents: |
        # Managed by Salt
        load_module {{ headers_more_m }};
    - require:
      - file: {{ headers_more_m }}
    - watch_in:
      - service: nginx
    - require_in:
      - service: nginx-reload
{% endif %}
