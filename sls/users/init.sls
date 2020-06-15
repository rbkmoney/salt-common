{% set users_present = salt.pillar.get('users:present', {}) %}
{% set users_present_list = users_present.keys() %}
{% set users_absent = salt.pillar.get('users:absent', []) %}

{% for groupname, data in salt.pillar.get('groups:present', {}).items() %}
group_{{ groupname }}:
  group.present:
    - name: {{ groupname }}
    {% if data and data.get('gid', False) != False %}
    - gid: {{ data.gid }}
    {% endif %}
{% endfor %}

{% for username, data in users_present.items() %}
{% set homedir = data.get('home', '/home/' + username) %}
user_{{ username }}:
  user.present:
    - name: {{ username }}
    - fullname: {{ data.get('fullname', '') }}
    - system: {{ data.get('system', False) }}
    {% if data.get('uid', False) != False %}
    - uid: {{ data['uid'] }}
    {% endif %}
    {% if data.get('gid', False) != False %}
    - gid: {{ data['gid'] }}
    {% endif %}
    - home: "{{ homedir }}"
    - createhome: {{ data.get('createhome', True) }}
    - shell: "{{ data.get('shell', '/bin/bash') }}"
    - password: "{{ data.get('passwd', '') }}"
    - groups: {{ data.get('groups', []) }}
    - optional_groups: {{ data.get('optional_groups', []) }}

{% if data.get('keys', False) %}
{{ homedir }}/.ssh:
  file.directory:
    - create: True
    - mode: 700
    - user: {{ username }}
    - require:
      - user: {{ username }}

{{ homedir }}/.ssh/authorized_keys:
  file.managed:
    - source: salt://users/files/authorized_keys.tpl
    - template: jinja
    - context:
        user: {{ username }}
    - mode: 600
    - user: {{ username }}
    - require:
      - file: {{ homedir }}/.ssh
{% endif %}

{% if data.get('pgpass', False) %}
{{ homedir }}/.pgpass:
  file.managed:
    - template: jinja
    - mode: 600
    - user: {{ username }}
    - require:
      - user: {{ username }}
    - content: |
       {% for l in data.pgpass %}
       {{ ':'.join((l.get('host', '*'),l.get('port', '*')|string,l.get('database', '*'),l.user,l.passwd)) }}
       {% endfor -%}
{% endif %}
{% endfor %}

{% for user in users_absent %}
{% if user not in users_present_list %}
{{ user }}:
  user.absent:
    - purge: True
{% endif %}
{% endfor %}
