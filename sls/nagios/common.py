#!pyobjects
# -*- mode: python -*-
from os import path

conf_path = pillar("nagios:dirs:conf", "/etc/nagios/")
if not conf_path.endswith('/'):
  conf_path += '/'
log_path = pillar("nagios:dirs:log", "/var/log/nagios/")
if not log_path.endswith('/'):
  log_path += '/'
var_path = pillar("nagios:dirs:var", "/var/lib/nagios/")
if not var_path.endswith('/'):
  var_path += '/'

pki_path = "/etc/pki/nagios/"
objects_path = path.join(conf_path, "objects/")
spool_path = path.join(var_path, "spool/")
archives_path = path.join(var_path, "archives/")
identity_path = "/root/.ssh/nagios-objects-access"
nagios_home = path.join(var_path, "home")

g_init = grains("init", "none")

p_nagios = pillar("nagios", {})
# p_tls = p_nagios.get("tls", {})
p_user = p_nagios.get("user", "nagios")
p_group = p_nagios.get("group", "nagios")

