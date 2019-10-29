{% if grains.selinux is defined and grains.selinux.enabled == True %}

 {% set se_pol_name = salt['augeas.get']('/files/etc/selinux/config/SELINUXTYPE')['/files/etc/selinux/config/SELINUXTYPE'] %}
 {% set seusers_file = '/etc/selinux/'+se_pol_name+'/seusers' %}

 {% for boolean in ['global_ssp','init_daemons_use_tty','tmpfiles_manage_all_non_security'] %}
{{ boolean }}:
    selinux.boolean:
      - value: True
      - persist: True
 {% endfor %}

 {% set users = pillar['users'] %}

 {% for user in users.present recursive %}
  {% if salt['user.info'](user) != {} and users.present[user].groups is defined %}
   {% set homedir = salt['user.info'](user).home %}
   {% set parenthomedir = salt['user.info'](user).home|replace(user, "") %}

semanage fcontext -a -e '/home' '{{ parenthomedir }}':
  cmd.run:
    - unless:
      - semanage fcontext -l|grep -E '^{{ parenthomedir }}\s'

restorecon -v {{ parenthomedir }}:
  cmd.run:
    - onchages:
      - cmd: semanage fcontext -a -e '/home' '{{ parenthomedir }}'

restorecon -Frv {{ homedir }}:
   {% if 'wheel' in users.present[user].groups and not salt['file.contains'](seusers_file, user+':staff_u') %}
  cmd.wait

semanage login -a -s staff_u {{ user }}:
  cmd.run:
    - watch_in:
        - cmd: restorecon -Frv {{ homedir }}
   {% elif 'user_home_dir_t' not in salt['file.get_selinux_context'](homedir) %}
  cmd.run
   {% else %}
  cmd.wait
   {% endif %}
  {% endif %}
 {% endfor %}

 {% for user in users.absent recursive %}
  {% if salt['file.contains'](seusers_file, user+':') %}
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
