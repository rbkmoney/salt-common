# -*- mode: yaml -*-
{% for username, data in salt['pillar.get']('users:present', {}).items() %}
{% set homedir = data.get('home', '/home/' + username) %}
{{ username }}_user:
  user.present:
    - name: {{ username }}
    - fullname: {{ data.get('fullname', '') }}
    {% if data.get('uid', False) != False %}
    - uid: {{ data['uid'] }}
    {% endif %}
    {% if data.get('gid', False) != False %}
    - gid: {{ data['gid'] }}
    {% else %}
    - gid_from_name: True
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
    - source: salt://users/authorized_keys.tpl
    - template: jinja
    - context:
        user: {{ username }}
    - mode: 600
    - user: {{ username }}
    - require:
      - file: {{ homedir }}/.ssh
{% endif %}
{% endfor %}
{% for user in salt['pillar.get']('users:absent', []) %}
{{ user }}:
  user.absent:
    - purge: True
{% endfor %}

{% for groupname, data in salt['pillar.get']('groups:present', {}).items() %}
{{ groupname }}_user:
  group.present:
    - name: {{ groupname }}
    {% if data.get('gid', False) != False %}
    - gid: {{ data['gid'] }}
    {% endif %}
{% endfor %}
