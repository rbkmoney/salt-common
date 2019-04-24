#!pyobjects
# -*- mode: python -*-
from salt.utils import dictupdate
import yaml

conf_path = '/etc/elasticsearch/'
log_path = '/var/log/elasticsearch/'
data_path = '/var/lib/elasticsearch/'

File.directory(
  conf_path, create=True,
  mode=755, user='root', group='root')

File.directory(
  log_path, create=True,
  mode=755, user='elasticsearch', group='elasticsearch')

File.directory(
  data_path, create=True,
  mode=755, user='elasticsearch', group='elasticsearch')

fqdn = grains('fqdn')
fqdn_ipv6 = grains('fqdn_ipv6')
hosts = pillar('elastic:hosts', [])

data_count = pillar('elastic:data-dir-count', False)
if data_count:
  _dirs = [data_path + 'data' + str(i) for i in range(0, data_count)]
  data_dir = ','.join(_dirs)
  for d in _dirs:
    File.directory(
      d, create=True,
      mode=755, user='elasticsearch', group='elasticsearch',
      require=[File(data_path)])
else:
  data_dir = data_path

limits = pillar('elastic:limits', {})
l_nofile = limits.get('nofile', 1048576)
l_memlock = limits.get('memlock', 'unlimited')
max_map_count = limits.get('max_map_count', 262144)
max_threads = limits.get('max_threads', 4096)

jvm = pillar('elastic:jvm', {})
jvm_heap_size = jvm.get('heap_size', '1g')
jvm_stack_size = jvm.get('stack_size', '1m')
jvm_extra_options = jvm.get('extra_options', {})

tls = pillar('elastic:tls', {})
tls_enabled = tls.get('enabled', False)
if tls:
  tls_transport = tls.get('transport', {})
  tls_http = tls.get('http', {})

# defaults
config = {
  'node': {
    'name': '${HOSTNAME}',
    'master': False, 'data': False, 'ingest': False,
    'max_local_storage_nodes': 1,
  },
  'bootstrap': {'memory_lock': True},
  'network': { 'host': '${HOSTNAME}' },
  'http': { 'port': 9200 },
  'gateway': { 'recover_after_nodes': len(hosts)/2 },
  'discovery': { 'zen': {
    'minimum_master_nodes': 1,
    'ping': { 'unicast': {}},
  }},
}

config['discovery']['zen']['ping']['unicast']['hosts'] = filter(
  lambda x: x != fqdn and x not in fqdn_ipv6,
  hosts)
if tls:
  config['opendistro_security'] = {
    'ssl': {
      'http': {
        'enabled': tls_http.get('enabled', tls_enabled),
        'enable_openssl_if_available': True,
        'pemcert_filepath': 'http-cert.pem',
        'pemkey_filepath': 'http-key.pem',
        'pemtrustedcas_filepath': 'http-ca.pem',
        'clientauth_mode': tls_http.get('clientauth_mode', 'OPTIONAL')
      },
      'transport': {
        'enabled': tls_transport.get('enabled', tls_enabled),
        'enable_openssl_if_available': True,
        'pemcert_filepath': 'transport-cert.pem',
        'pemkey_filepath': 'transport-key.pem',
        'pemtrustedcas_filepath': 'transport-ca.pem',
        'enforce_hostname_verification': True
      },
    }
  }

dictupdate.update(config, pillar('elastic:config'))

File.managed(
  conf_path + 'elasticsearch.yml',
  mode=644, user='root', group='root',
  contents="# This file is generated by Salt\n" + yaml.dump(config),
  require=[File(conf_path)])

File.managed(
  conf_path + 'jvm.options',
  mode=644, user='root', group='root',
  template='jinja', source='salt://elasticsearch/files/jvm.options.tpl',
  defaults={'heap_size': jvm_heap_size, 'stack_size': jvm_stack_size,
            'extra_options': jvm_extra_options},
  require=[File(conf_path)])

File.managed(
  '/etc/conf.d/elasticsearch',
  mode=644, user='root', group='root',
  template='jinja', source="salt://elasticsearch/files/elasticsearch.confd.tpl",
  defaults={
    'conf_dir': conf_path, 'log_dir': log_path, 'data_dir': data_dir,
    'es_java_opts': '', 'l_nofile': l_nofile, 'l_memlock': l_memlock,
    'max_map_count': max_map_count, 'max_threads': max_threads, 'es_startup_sleep_time': 10})

if tls:
  for proto in ('transport', 'http'):
    for pemtype in ('cert', 'key', 'ca'):
      File.managed(
        conf_path + proto + '-' + pemtype + '.pem',
        mode=600, user='elasticsearch', group='elasticsearch',
        contents=tls[proto].get(pemtype, tls.get(pemtype, '')),
        require=[File(conf_path)])

File.managed(
  '/etc/security/limits.d/elasticsearch.conf',
  mode=644, user='root', group='root',
  contents='\n'.join([
    "elasticsearch soft nofile {0}".format(l_nofile),
    "elasticsearch hard nofile {0}".format(l_nofile),
    "elasticsearch soft memlock {0}".format(l_memlock),
    "elasticsearch hard memlock {0}".format(l_memlock)]))
