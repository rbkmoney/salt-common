{% if grains.selinux is defined and grains.selinux.enabled == True %}

{% set policy_type = salt['cmd.shell']["sestatus |grep 'Loaded policy name'|awk '{print $4}'"] %}

 {% for boolean in ['global_ssp','init_daemons_use_tty','tmpfiles_manage_all_non_security'] %}
{{ boolean }}:
    selinux.boolean:
      - value: True
      - persist: True
 {% endfor %}

/tmp:
  mount.mounted:
    - device: tmpfs
    - fstype: tmpfs
    - opts: defaults,size=100M,noexec,nosuid,{% if policy_type == 'mcs' or 'mls' %}rootcontext=system_u:object_r:tmp_t:s0{% else %}rootcontext=system_u:object_r:tmp_t{% endif%} 
    - dump: 0
    - pass_num: 0
    - persist: True
    - mkmnt: True

{% endif %}
