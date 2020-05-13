include:
  - salt.roots

/var/salt/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/var/salt/ssh/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode: 700
    - require:
      - file: /var/salt/

{% set identity_file = '/var/salt/ssh/salt' %}
{{ identity_file }}:
  file.managed:
    - replace: False
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: /var/salt/ssh/

{% set main_reponame = salt['pillar.get']('salt:repos:main:name', 'local') %}
{% set main_remote_uri = salt['pillar.get']('salt:repos:main:remote') %}
{% set extra_repos = salt['pillar.get']('salt:repos:extra', {} ) %}
{% set extra_reponames = extra_repos|list %}

{% set sync_reponames = salt['pillar.get']('salt:repos:sync-reponames', []) %}
{% set sync_branches = salt['pillar.get']('salt:repos:sync-branches', []) %}

# if a pillar was not passed in, then get the list of branches from main remote.
{% if not sync_reponames or not sync_branches %}
{% set sync_reponames = [main_reponame] + extra_reponames %}
{% for origin_branch in salt.git.ls_remote(remote=main_remote_uri, opts='--heads',
   identity=identity_file) %}
{% set branch_name = origin_branch.replace('refs/heads/', '') %}
{% if not '/' in branch_name %}{% do sync_branches.append(branch_name) %}{% endif %}
{% endfor %}

# Delete directories of deleted main branches, since we're looking at all main remote branches
{% for reponame in sync_reponames %}
{% for dir in salt['file.find']('/var/salt/' + reponame, type='d', maxdepth=1)
   if (dir.split('/')[-1] not in [reponame, "_mirror"] + sync_branches) %}
{{ dir }}:
  file.absent:
    - require_in:
      - file: /etc/salt/master.d/roots.conf
{% endfor %}
{% endfor %}
{% endif %}

{% for reponame in sync_reponames %}
/var/salt/{{ reponame }}:
  file.directory:
    - create: True
{% if reponame == main_reponame %}
{% set remote_uri = main_remote_uri %}
{% set remote_branches = sync_branches %}
{% set fixed_branch = None %}
{% else %}
{% set remote_uri = extra_repos[reponame].get('remote', None) %}
{% if remote_uri %}
{% set remote_branches = [] %}
{% for origin_branch in salt.git.ls_remote(remote=remote_uri, opts='--heads',
   identity=identity_file) %}
{% set branch = origin_branch.replace('refs/heads/', '') %}
{% do remote_branches.append(branch) %}
{% endfor %}
{% endif %}
{% set fixed_branch = extra_repos[reponame].get('branch', None) %}
{% if remote_uri and fixed_branch and fixed_branch not in sync_branches %}
{% do sync_branches.append(fixed_branch) %}
{% endif %}
{% endif %}

{% if remote_uri %}
salt-repo-{{ reponame }}-_mirror:
  git.latest:
    - name: {{ remote_uri }}
    - target: /var/salt/{{ reponame }}/_mirror
    - bare: True
    - mirror: True
    - user: root
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - identity: "{{ identity_file }}"
    - require:
      - file: /var/salt/ssh/salt
      - file: /var/salt/{{ reponame }}
    - require_in:
      - file: /etc/salt/master.d/roots.conf

{% for branch in remote_branches if branch in sync_branches or branch == fixed_branch %}
# Those directories are required for correct roots.conf generation on the first run
{% set i = salt['file.mkdir']('/'.join(('/var/salt', reponame, branch, 'sls')), mode=750) %}
{% set i = salt['file.mkdir']('/'.join(('/var/salt', reponame, branch, 'pillar')), mode=750) %}
salt-repo-{{ reponame }}-{{ branch }}:
  git.latest:
    - name: /var/salt/{{ reponame }}/_mirror
    - target: /var/salt/{{ reponame }}/{{ branch }}
    - rev: {{ branch }}
    - branch: {{ branch }}
    - user: root
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require:
      - git: salt-repo-{{ reponame }}-_mirror
    - require_in:
      - file: /etc/salt/master.d/roots.conf
{% endfor %}
{% endif %}
{% endfor %}

salt-roots-restart:
  service.running:
    - name: {{ 'salt-minion' if salt['grains.get']('salt:masterless', False) else 'salt-master' }}
    - watch:
      - file: /etc/salt/master.d/roots.conf
