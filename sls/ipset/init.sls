{% set ipsets_present = salt['pillar.get']('ipsets:present', {}) %}
{% set ipsets_present_list = [] %}
{% set ipsets_absent = salt['pillar.get']('ipsets:absent', {}) %}

{% for set_prefix, set_types in ipsets_present.items() %}
{% for set_type, ip_families in set_types.items() %}
{% for set_family, set_items in ip_families.items() %}
{% set set_name = set_prefix + '-' + set_type + '-' + set_family %}
{% do ipsets_present_list.append(set_name) %}
{{ set_name }}:
    ipset.set_present:
        - set_type: hash:{{ set_type }}
        - family: {{ set_family }}
        - comment: True

{% for set_comments, set_entries in set_items.items() %}
{{ set_name }}-items-{{ loop.index }}:
    ipset.present:
        - set_name: {{ set_name }}
        - comment: {{ set_comments }}
        - entry:
            {% for entry in set_entries %}
            - {{ entry }}
            {% endfor %}
        - require:
            - ipset: {{ set_name }}

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}

{% for set_prefix, set_types in ipsets_absent.items() %}
{% for set_type, ip_families in set_types.items() %}
{% for set_family, set_items in ip_families.items() %}
{% set set_name = set_prefix + '-' + set_type + '-' + set_family %}
{% if set_name in ipsets_present_list %}
{% for set_comments, set_entries in set_items.items() %}
{{ set_name }}-absent-items-{{ loop.index }}:
    ipset.absent:
        - set_name: {{ set_name }}
        - comment: {{ set_comments }}
        - entry:
            {% for entry in set_entries %}
            - {{ entry }}
            {% endfor %}
        - require:
            - ipset: {{ set_name }}

{% endfor %}
{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
