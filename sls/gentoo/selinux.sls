{% if grains.selinux is defined and grains.selinux.enabled == True %}

 {% set se_pol_name = salt['augeas.get']('/files/etc/selinux/config/SELINUXTYPE')|string %}
 {% set seusers_file = '/etc/selinux/'+se_pol_name+'/seusers' %}

 {% for boolean in ['global_ssp','init_daemons_use_tty','tmpfiles_manage_all_non_security'] %}
{{ boolean }}:
    selinux.boolean:
      - value: True
      - persist: True
 {% endfor %}

 {% set users = pillar['users'] %}

 {% for user in users.present recursive %}
  {% if users.present[user].groups is defined %}
   {% if 'wheel' in users.present[user].groups and not salt['file.grep'](seusers_file, user+':staff_u') %}
semanage login -a -s staff_u {{ user }}:
  cmd.run

restorecon -Frv /home/{{ user }}:
  cmd.run:
    - require:
      - cmd: semanage login -a -s staff_u {{ user }}
   {% endif %}
  {% endif %}
 {% endfor %}

 {% for user in users.absent recursive %}
  {% if salt['file.grep'](seusers_file, user+':staff_u') %}
semanage login -d {{ user }}:
  cmd.run
  {% endif %}
 {% endfor %}

run_init:
  augeas.change:
    - context: /files/etc/pam.d/run_init
    - changes:
      - ins 01 before "*[type='auth'][control='include'][module='system-auth']"
      - set /01/type auth
      - set /01/control sufficient
      - set /01/module pam_rootok.so
    - unless: grep -v "^#" /etc/pam.d/run_init | grep pam_rootok.so

sec-policy/selinux-custom-server:
  pkg.latest

{% endif %}
