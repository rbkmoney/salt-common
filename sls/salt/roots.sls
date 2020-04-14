#!pydsl
# -*- mode: python -*-
import yaml
from os import path
from glob import glob

d_salt = '/var/salt'
main_reponame = __salt__['pillar.get']('salt:repos:main:name', 'local')
extra_repos = __salt__['pillar.get']('salt:repos:extra', {})
branches = filter(lambda x: x not in (main_reponame, '.git', '_mirror'),
                  map(path.basename,
                      filter(path.isdir, glob(path.join(d_salt, main_reponame, '*')))))

content = {'file_roots': {}, 'pillar_roots': {}}

for branch in branches:
  if branch == 'master':
    env_name = 'base'
  else:
    env_name = branch
  content['file_roots'][env_name] = [path.join(d_salt, main_reponame, branch, 'sls')]
  content['pillar_roots'][env_name] = [path.join(d_salt, main_reponame, branch, 'pillar')]
  for repo_name, data in extra_repos.items():
    if 'branch' in data:
      content['file_roots'][env_name].append(path.join(d_salt, repo_name, data['branch'], 'sls'))
      content['pillar_roots'][env_name].append(path.join(d_salt, repo_name, data['branch'], 'pillar'))
    else:
      if (path.isdir(path.join(d_salt, repo_name, branch, 'sls'))
          and path.isdir(path.join(d_salt, repo_name, branch, 'pillar'))):
        content['file_roots'][env_name].append(path.join(d_salt, repo_name, branch, 'sls'))
        content['pillar_roots'][env_name].append(path.join(d_salt, repo_name, branch, 'pillar'))
      elif 'default-branch' in data:
        content['file_roots'][env_name].append(path.join(d_salt, repo_name, data['default-branch'], 'sls'))
        content['pillar_roots'][env_name].append(path.join(d_salt, repo_name, data['default-branch'], 'pillar'))

  content['file_roots'][env_name].append(path.join(d_salt, 'private', 'files'))
  content['pillar_roots'][env_name].append(path.join(d_salt, 'private', 'pillar'))

state('/etc/salt/master.d/roots.conf').file.managed(
  mode='644', user='root',
  contents=yaml.dump(content))
