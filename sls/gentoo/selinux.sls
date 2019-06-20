{% if grains.selinux is defined and grains.selinux.enabled == True %}

 {% for boolean in ['global_ssp','init_daemons_use_tty','tmpfiles_manage_all_non_security'] %}
{{ boolean }}:
    selinux.boolean:
      - value: True
      - persist: True
 {% endfor %}

{% endif %}
