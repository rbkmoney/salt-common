ldns:
  pkg.latest:
    - pkgs:
      - net-libs/ldns: "[ecdsa,dane,ssl]"
  {% if grains['osarch'].startswith('arm') %}
  portage_config.flags:
    - name: net-libs/ldns
    - accept_keywords:
      - ~arm
    - watch_in:
      - pkg: ldns
  {% endif %}
