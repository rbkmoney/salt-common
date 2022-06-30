#!pyobjects
# -*- mode: python -*-
import yaml

suricata = pillar('suricata', {})
instances = suricata.get('instances', {})
rules_repo = pillar('suricata:rules:remote', '')
rules_commit = pillar('suricata:rules:commit', '')
identity_file = '/root/.ssh/suricata-rules-access'

include('suricata.pkg')

suricata_confd='/etc/conf.d/suricata'
confd_contents="""# Managed by Salt
# Config file for /etc/init.d/suricata
"""

for name, data in instances.items():
  for key in ('OPTS','LOG_FILE','USER','GROUP'):
    if 'SURICATA_' + key in data:
      confd_contents += '_'.join(('SURICATA', key, name)) + '="' + data['SURICATA_' + key] + '"\n'

File.managed(suricata_confd, mode=644, user='root', group='root', contents=confd_contents)

for name, data in instances.items():
  rules_dir = '/etc/suricata/rules-' + name
  suricata_service = 'suricata.' + name
  suricata_yaml = '/etc/suricata/'+ suricata_service.replace('.', '-') +'.yaml'
  initd_symlink = '/etc/init.d/' + suricata_service
  Service.running(suricata_service, enable=True, reload=True,
                  watch=(File(suricata_confd), Pkg('net-analyzer/suricata')))

  File.directory(
    rules_dir,
    create=True,
    user='root',
    group='root')

  with Service(suricata_service, 'watch_in'):
    File.symlink(initd_symlink, target='/etc/init.d/suricata')
    File.managed(
      suricata_yaml, mode=644, user='root', group='root',
      check_cmd='suricata --init-errors-fatal -v -T -c',
      contents='%YAML 1.1\n---\n' + yaml.dump(
        data['conf'] if 'conf' in data else suricata['conf']))
    Git.latest(
      'git-suricata-rules-' + name,
      name=rules_repo,
      target=rules_dir,
      rev='master',
      force_clone=True,
      force_checkout=True,
      force_reset=True,
      identity=identity_file,
      require_in=(File(suricata_yaml)),
      require=(File(rules_dir), File(identity_file)))

File.managed(
  '/etc/logrotate.d/suricata', source='salt://suricata/files/suricata.logrotate',
  template='jinja', defaults={'instances': list(instances.keys())},
  mode=644, user='root', group='root')

File.managed(
  identity_file,
  source='salt://ssl/openssh-privkey.tpl',
  template='jinja',
  context={'privkey_key': 'suricata-rules-access'},
  mode=600,
  user='root',
  group='root')
