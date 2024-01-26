/etc/hosts:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - contents: |
        # Managed by Salt
        # IPv4 and IPv6 localhost aliases
        127.0.0.1 localhost
        ::1 localhost
        {% if grains.fqdn_ip4 %}
        {% for a in grains.fqdn_ip4 %}
        {{ a }} {{ grains.id }} {{ grains.localhost }}
        {% endfor %}
        {% endif %}
        {% if grains.fqdn_ip6 %}
        {% for a in grains.fqdn_ip6 %}
        {{ a }} {{ grains.id }} {{ grains.localhost }}
        {% endfor %}
        {% endif %}
        {% for a,n in salt.pillar.get("hosts:extra", []) %}
        {{ a }} {{ " ".join(n) }}
        {% endfor %}
