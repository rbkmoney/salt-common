#!pyobjects
# -*- mode: python -*-
import yaml

suricata = pillar('suricata', {})
instances = suricata.get('instances', {})

include('suricata.pkg')

suricata_confd='/etc/conf.d/suricata'
confd_contents="""# Managed by Salt
# Config file for /etc/init.d/suricata
"""

for name,data in instances.items():
  for key in ('OPTS','LOG_FILE','USER','GROUP'):
    if 'SURICATA_' + key in data:
      confd_contents += '_'.join(('SURICATA', key, name)) + '="' + data['SURICATA_' + key] + '"\n'

File.managed(suricata_confd, mode=644, user='root', group='root', contents=confd_contents)

for name,data in instances.items():
  suricata_service = 'suricata.' + name
  suricata_yaml = '/etc/suricata/'+ suricata_service +'.yaml'
  initd_symlink = '/etc/init.d/' + suricata_service
  Service.running(suricata_service, enable=True,
                  watch=(File(suricata_confd), Pkg('net-analyzer/suricata')))

  with Service(suricata_service, 'watch_in'):
    File.symlink(initd_symlink, target='/etc/init.d/suricata')
    File.managed(
      suricata_yaml, mode=644, user='root', group='root',
      check_cmd='suricata -T -c'
      contents='%YAML 1.1\n---\n' + yaml.dump(
        data['conf'] if 'conf' in data else suricata['conf']))
