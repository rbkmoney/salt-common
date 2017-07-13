#!pydsl
import yaml

suricata = __salt__['pillar.get']('suricata', {})
instances = suricata.get('instances', {})

include('suricata.pkg')

confd_suricata = state('/etc/conf.d/suricata').file
confd_contents="""# Managed by Salt
# Config file for /etc/init.d/suricata"""

for name,data in instances.items():
  for key in ('OPTS','LOG_FILE','USER','GROUP'):
    if 'SURICATA_' + key in data:
      confd_contents += '_'.join(('SURICATA', key, name)) + '="' + data['SURICATA_' + key] + '"\n'

confd_suricata.managed(mode=644, user='root', group='root', contents=confd_contents)

for name,data in instances.items():
  suricata_yaml = state('/etc/suricata/suricata-' + name + '.yaml').file
  initd_symlink = state('/etc/init.d/suricata.' + name).file
  
  suricata_yaml.managed(
    mode=644, user='root', group='root',
    contents='%YAML 1.1\n---\n' + yaml.dump(data['conf'] if 'conf' in data
                                            else suricata['conf']))

  initd_symlink.symlink(target='/etc/init.d/suricata')

  state('suricata.' + name).\
    service.running(enable=True).\
    watch(confd_suricata, suricata_yaml, initd_symlink,
          pkg='net-analyzer/suricata')
