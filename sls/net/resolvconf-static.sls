{% set resc = salt.pillar.get("resolvconf:static") %}
/etc/resolv.conf:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - contents: |
        # Managed by Salt
        {% for a in resc.get("nameservers", []) %}
        nameserver {{ a }}
        {% endfor %}
        {% if "search" in resc %}
        search {{ " ".join(resc["search"]) }}
        {% endif %}
        {% if "sortlist" in resc %}
        sortlist {{ " ".join(resc["sortlist"]) }}
        {% endif %}
        {% if "options" in resc %}
        options {{ " ".join(resc["options"]) }}
        {% endif %}
