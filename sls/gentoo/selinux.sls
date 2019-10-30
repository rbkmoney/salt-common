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
  {% set userinfo = salt['user.info'](user) %}
  {% if userinfo != {} and users.present[user].keys is defined and userinfo.home != '/root' and userinfo.shell == "/bin/bash" %}
   {% set homedir = salt['user.info'](user).home %}
   {% set parenthomedir = salt['user.info'](user).home|replace("/home/"+user, "/home") %}

check parent dir for {{ user }} homedir:
  cmd.run:
    - name: semanage fcontext -a -e '/home' '{{ parenthomedir }}'
    - unless:
      - grep -E '^{{ parenthomedir }}\s' /etc/selinux/{{ se_pol_name }}/contexts/files/file_contexts*

restorecon parent dir for {{ user }} homedir:
  cmd.run:
    - name: restorecon -v {{ parenthomedir }}
    - onchanges:
      - cmd: check parent dir for {{ user }} homedir
   {% if salt['user.info'](user) != {} %}
restorecon -Frv {{ homedir }}:
    {% if users.present[user].groups is defined and 'wheel' in users.present[user].groups and not salt['file.contains'](seusers_file, user+':staff_u') %}
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
