# -*- mode: nginx -*-
{% set mirror_types = salt['pillar.get']('gentoo-mirror:types', []) %}
{% set mirror_servers = salt['pillar.get']('gentoo-mirror:servers', []) %}

proxy_cache_path /var/cache/nginx/gentoo-mirror levels=1:2 keys_zone=gentoo-mirror:32m inactive=1d max_size=1000m;

{% if 'gentoo-distfiles' in mirror_types %}
upstream gentoo-distfiles-servers {
    {% for hostname,params in mirror_servers['gentoo-distfiles'].items() %}
    server {{ hostname }}; # TODO: Handle params
    {% endfor %}
}
{% endif %}

{% if 'packages' in mirror_types %}
{% for inst in salt['pillar.get']('mirror:gentoo-package-repos', []) %}
upstream gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages-servers {
    {% for hostname,params in mirror_servers['gentoo-'+inst['arch']+'-'+inst['cpu_arch']+'-packages'].items() %}
    server {{ hostname }}; # TODO: Handle params
    {% endfor %}
}
{% endfor %}
{% endif %}

server {
    include listen;
    {% if ssl %}
    include listen_ssl;
    ssl_certificate {{ ssl_cert_path }};
    ssl_certificate_key {{ ssl_key_path }};
    {% endif %}
    server_name {{ server_name }};
    
    include includes/errors.conf;
    
    {% if 'gentoo-distfiles' in mirror_types %}
    location ^~ /gentoo-distfiles/ {
        include proxy_params; #!
        proxy_cache gentoo-mirror;
        proxy_cache_key "$proxy_host$request_uri";
        proxy_cache_revalidate on;
        proxy_cache_min_uses 1;
        proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
        proxy_cache_lock on;
        add_header X-Cache-Status $upstream_cache_status;
        proxy_pass gentoo-distfiles-servers;
    }
    {% endif %}
    {% if 'packages' in mirror_types %}
    {% for inst in salt['pillar.get']('mirror:gentoo-package-repos', []) %}
    location /gentoo-packages/{{ inst['arch'] }}/{{ inst['cpu_arch'] }}/packages/ {
        include proxy_params; #!
        proxy_cache gentoo-mirror;
        proxy_cache_key "$proxy_host$request_uri";
        proxy_cache_revalidate on;
        proxy_cache_min_uses 1;
        proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
        proxy_cache_lock on;
        proxy_pass gentoo-distfiles-servers;
        add_header X-Cache-Status $upstream_cache_status;
        proxy_pass gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages-servers;
    }
    {% endfor %}
    {% endif %}
}
