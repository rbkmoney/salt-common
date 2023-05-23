#!pyobjects

File.absent('/etc/sysctl.d/ipv6_forwarding.conf')
File.absent('/etc/sysctl.d/10-network-security.conf')

net = pillar('sysctl:net', {})

def walk(path, data):
  for key, value in data.items():
    if isinstance(value, dict):
      walk(path + '.' + key, value)
    else:
      Sysctl.present(path + '.' + key, config='/etc/sysctl.d/net.conf', value=str(value))

walk('net', net)
