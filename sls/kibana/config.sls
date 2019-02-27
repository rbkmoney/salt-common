#!pydsl
# -*- mode: python -*-
from salt.utils import dictupdate
import yaml

state('/etc/kibana').file.directory(
  create=True, mode=755, user='root', group='root')

fqdn = __salt__['grains.get']('fqdn')
fqdn_ipv6 = __salt__['grains.get']('fqdn_ipv6')


# defaults
config = {
  'server': {
    'port': 5601,
    'host': '::1',
    'basePath': '',
  },
  'elasticsearch': {
    'url': "http://localhost:9200",
    'preserveHost': True,
  },
  'kibana': {
    'index': ".kibana",
  },
  'pid': { 'file': '/run/kibana.pid' },
  'logging': {
    'dest': '/var/log/kibana/kibana.log',
  },
}

dictupdate.update(config, __pillar__['kibana']['config'])

state('/etc/kibana/kibana.yml').file.managed(
  mode=644, user='root', group='root',
  contents="# This file is generated by Salt\n" + yaml.dump(config))
