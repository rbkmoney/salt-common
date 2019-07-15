proc_view:
  group.present:
    - gid: 391
    - system: True
  {%- if salt['cmd.retcode']('id polkitd') == 0 %}
    - addusers:
      - polkitd
  {%- endif %}

/proc:
  mount.mounted:
    - device: proc
    - fstype: proc
    - dump: 0 
    - pass_num: 0
    - persist: True
    - mkmnt: True
    - opts:
      - defaults
      - nosuid
      - nodev
      - noexec
      - relatime
      - hidepid=2
      - gid=391
    - require:
      - group: proc_view
