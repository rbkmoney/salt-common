{% if pillar["netplan"]["config"] is defined %}
netplan_cfg:
  file.serialize:
    - name: /etc/netplan/99-netcfg-{{ grains['virtual'] }}.yaml
    - dataset_pillar: netplan:config
    - formatter: yaml
    - makedirs: True

netplan_run:
  cmd.run:
    - name: netplan generate && netplan apply
    - onchanges:
        - file: netplan_cfg
{% endif %}
