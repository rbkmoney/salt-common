include:
  - lib.ldns

ldns-utils:
  pkg.latest:
    - pkgs:
      - net-dns/ldns-utils: "[ecdsa,dane,ssl]"
  {% if grains['osarch'].startswith('arm') %}
  portage_config.flags:
    - name: net-dns/ldns-utils
    - accept_keywords:
      - ~arm
    - watch_in:
      - pkg: ldns-utils
  {% endif %}
