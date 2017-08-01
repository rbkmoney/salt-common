#!pydsl
# -*- mode: python -*-
import yaml
from os import path
from glob import glob

d_salt = '/var/salt'
main_reponame = __salt__['pillar.get']('salt:repos:main:name', 'local')
common_reponame = __salt__['pillar.get']('salt:repos:common:name', 'common')
extra_repos = __salt__['pillar.get']('salt:repos:extra', {})
branches = filter(lambda x: x not in (main_reponame, '.git'),
                  map(path.basename,
                      filter(path.isdir, glob(path.join(d_salt, main_reponame, '*')))))

content = {'file_roots': {}, 'pillar_roots': {}}

for branch in branches:
  if branch == 'master':
    env_name = 'base'
  else:
    env_name = branch
  content['file_roots'][env_name] = (
    [path.join(d_salt, main_reponame, branch, 'sls'),
     path.join(d_salt, 'private', 'files'), 
     path.join(d_salt, common_reponame, 'sls')] +
    filter(path.isdir, [path.join(d_salt, repo_name, extra_repos[repo_name].get('branch', branch), 'sls')
                        for repo_name in extra_repos.keys()]))
  content['pillar_roots'][env_name] = (
    [path.join(d_salt, main_reponame, branch, 'pillar'),
     path.join(d_salt, common_reponame, 'pillar')] +
    filter(path.isdir, [path.join(d_salt, repo_name, extra_repos[repo_name].get('branch', branch), 'pillar')
                        for repo_name in extra_repos.keys()]))

content['pillar_roots']['base'].append(path.join(d_salt, 'private', 'pillar'))

state('/etc/salt/master.d/roots.conf').file.managed(
  mode='644', user='root',
  contents=yaml.dump(content))
