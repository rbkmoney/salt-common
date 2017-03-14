nagios-plugins:
  pkg.purged:
    - name: net-analyzer/nagios-plugins
  portage_config.flags:
    - accept_keywords: []
    - use: []

monitoring-plugins:
  pkg.installed:
    - pkgs:
      - net-analyzer/monitoring-plugins: "~2.1.2::baka-bakka"
      - net-analyzer/fping: "~"
      - dev-perl/Net-SNMP: "~"
      - dev-perl/Crypt-DES: "~"
      - dev-perl/Crypt-Rijndael: "~" # Required by dev-perl/Net-SNMP on arm.
    - require:
      - portage_config: monitoring-plugins
      - pkg: nagios-plugins
  portage_config.flags:
    {% set extra_use = salt['pillar.get']('monitoring-plugins:extra_use') %}
    - use:
      - ssh
      - ssl
      - dns
      - fping
      - snmp
      {% for use in ('mysql', 'postgres', 'samba', 'ldap', 'game')%}
      {% if use in extra_use -%} - {{ use }} {%- endif %}
      {% endfor %}
