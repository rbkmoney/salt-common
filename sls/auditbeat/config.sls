#!pyobjects
## -*- mode: python -*-
from salt.utils import dictupdate
import yaml
import json

fqdn = grains('fqdn')
fqdn_ipv6 = grains('fqdn_ipv6')
conf_path = '/etc/auditbeat/'

File.directory(conf_path, create=True, mode=755, user='root', group='root')
File.managed(
  conf_path + 'audit.rules',
  source="salt://auditbeat/files/audit.rules.tpl",
  template="jinja",
  mode=644, user='root', group='root',
  require=[File(conf_path)])

tls = pillar('auditbeat:tls', {})

# defaults
config = {
  'name': str(fqdn),
  'setup': {'template':{'enabled': False},
            'ilm':{'enabled': False}},
  'logging': {
    'level': 'info',
    'selectors': ["*"],
    'to_files': True,
    'to_syslog': False,
    'files': {
      'path': '/var/log/auditbeat',
      'name': 'auditbeat.log',
      'keepfiles': 7,
    }},
  'auditbeat': {},
  'output': {}}

modules = {
      'auditd': {
       'audit_rule_files': [ '${path.config}/audit.rules' ]},
      'file_integrity': {
       'recursive': True,
       'paths': ['/bin','/sbin/','/lib','/lib64',
                 '/usr/bin','/usr/sbin','/usr/lib','/usr/lib64',
                 '/etc'],
       'exclude_files': [
         '^/etc/lvm/(backup|archive)',
         '^/etc/portage/package\.',
         '^/etc/salt/pki/master/minions/',
         '^/etc/salt/gpgkeys/pubring.kbx.lock',
         '^/etc/dnssec/root-anchors.txt']}}

dictupdate.update(modules, pillar('auditbeat:modules', {}))
config['auditbeat']['modules'] = [dict(module=n, **c) for n, c in modules.items()]
config['output'] = pillar('auditbeat:output')

for out in config['output'].keys():
  if out in tls.keys():
    out_ssl = {}
    config['output'][out]['ssl'] = out_ssl
    out_ssl['enabled'] = tls[out].get('enabled', True)
    for pemtype in ('cert', 'key', 'ca'):
      contents = tls[out].get(pemtype, tls.get(pemtype, ''))
      path = conf_path + out + '-' + pemtype + '.pem'
      if contents:
        if pemtype == 'cert': out_ssl['certificate'] = path
        if pemtype == 'key': out_ssl['key'] = path
        if pemtype == 'ca': out_ssl['certificate_authorities'] = [path]
      File.managed(
        path, mode=600, user='root', group='root',
        contents=contents, require=[File(conf_path)])

dictupdate.update(config, pillar('auditbeat:config', {}))

File.managed(
  conf_path + 'auditbeat.yml',
  mode=640, user='root', group='root',
  # check_cmd='auditbeat test config -c',
  contents="# This file is generated by Salt\n" + yaml.dump(config),
  require=[File(conf_path)])