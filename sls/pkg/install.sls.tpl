{% set packages_pillar_root = "gentoo:portage:packages" %}
{% set package_params = salt.pillar.get(packages_pillar_root + ":" + package_name) %}

{{ package_name }}:
  pkg.installed:
    - pkgs:
      {% if ('version' in package_params) or ('use' in package_params) %}
      - {{ package_name }}: "{{ package_params.get('version', '') }}[{{ ','.join(package_params.get('use', None)) }}]"
      {% else %}
      - {{ package_name }}
      {% endif %}
      - app-editors/nano
    - watch:
      - portage_config: {{ package_name }}
  portage_config.flags:
    {% for flag in ('use', 'mask') %}
      {% if flag in package_params %}
        {% set flag_elements = [package_params.get(flag)] if package_params.get(flag) is string else package_params.get(flag) %}
    - {{ flag }}:
        {% for e in flag_elements %}
      - {{ e }}
        {% endfor %}
      {% endif %}
    {% endfor %}
    {% if 'accept_keywords' in package_params %}
    - accept_keywords: {{ package_params.get('accept_keywords') }}
    {% endif %}