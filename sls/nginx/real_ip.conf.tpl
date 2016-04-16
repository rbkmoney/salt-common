{% for ip in ips %}
set_real_ip_from {{ ip }};
{% endfor %}
real_ip_header {{ header }};
