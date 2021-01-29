# -*- mode: nginx -*-
{% set src_host = salt['pillar.get']('gentoo-mirror:src-host',
    'gentoo.'+salt['grains.get']('domain', 'localdomain')) %}

{% set server_name = salt['pillar.get']('gentoo-mirror:server-name',
      ['gentoo.'+salt['grains.get']('domain', 'localdomain')]) %}

{% set mirror_types = salt['pillar.get']('gentoo-mirror:types', []) %}
{% set mirror_cache = salt['pillar.get']('gentoo-mirror:proxy-cache', {}) %}
{% set mirror_servers = mirror_cache['servers'] %}
{% set package_repos = salt['pillar.get']('gentoo-mirror:gentoo-package-repos', []) %}
{% set proxy_scheme = 'https' if ssl else 'http' %}
proxy_cache_path /var/cache/nginx/gentoo-mirror levels=1:2
keys_zone=gentoo-mirror:{{ mirror_cache.get('hash-size', '32m') }}
inactive={{ mirror_cache.get('inactive', '1d') }}
max_size={{ mirror_cache.get('max-size', '8192m') }};

{% if 'gentoo-distfiles' in mirror_types %}
upstream gentoo-distfiles-servers {
    {% for hostname,params in mirror_servers['gentoo-distfiles'].items() %}
    server {{ hostname }}; # TODO: Handle params
    {% endfor %}
}
{% endif %}

{% if 'packages' in mirror_types %}
{% for inst in package_repos %}
upstream gentoo-{{ inst['arch']+'-'+inst['cpu_arch'] }}-packages-servers {
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
    server_name {% for name in server_name %}{{ name }} {% endfor %};
    
    include includes/errors.conf;
    
    {% if 'gentoo-distfiles' in mirror_types %}
    location ^~ /gentoo-distfiles/ {
        proxy_set_header Host {{ src_host }};
        include includes/gentoo-mirror-proxy-params.conf;
        proxy_pass {{ proxy_scheme }}://gentoo-distfiles-servers;
    }
    {% endif %}
    {% if 'packages' in mirror_types %}
    {% for inst in package_repos %}
    location ^~ /gentoo-packages/{{ inst['arch']+'/'+inst['cpu_arch'] }}/packages/ {
        proxy_set_header Host {{ src_host }};
        include includes/gentoo-mirror-proxy-params.conf;
        proxy_pass {{ proxy_scheme }}://gentoo-{{ inst['arch']+'-'+inst['cpu_arch'] }}-packages-servers;
    }
    {% endfor %}
    {% endif %}
}
