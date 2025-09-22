# -*- mode: nginx -*-
# Managed by Salt
{% set default_vhost = salt.pillar.get("nginx:default-vhost", {}) %}
server {
    listen 80 default;
    listen [::]:80 default ipv6only=on;
    listen 443 default ssl;
    listen [::]:443 default ssl ipv6only=on;
    server_name default;

    ssl_certificate {{ default_vhost.get("cert", "/etc/ssl/nginx/nginx.pem") }};
    ssl_certificate_key {{ default_vhost.get("key", "/etc/ssl/nginx/nginx.key") }};
    access_log /var/log/nginx/default_access.json {{ default_vhost.get("log-format", "elastic_json") }};

    {% if default_vhost.get("redirect-url", False) %}
    location / {
      return 301 "{{ default_vhost["redirect-url"] }}";
    }
    {% else %}
    root /var/www/default/htdocs;
    {% endif %}
}
