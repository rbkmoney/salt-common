#!pyobjects
# -*- mode: python -*-
from os import path
from salt.utils import dictupdate

from salt://nagios/common.py import p_nagios,p_user,p_group
from salt://nagios/common.py import g_init
from salt://nagios/common.py import conf_path,pki_path,log_path,var_path
from salt://nagios/common.py import objects_path,identity_path,nagios_home
from salt://nagios/common.py import spool_path,archives_path

include("users")
include("ssl.dirs")
include(".server-pkg")

p_extra_vault_states = p_nagios.get("extra-vault-states", {})

File.directory(conf_path,
               create=True,
               mode=755,
               user=p_user,
               group=p_group,
               require=[User(p_user)])
    
File.managed(path.join(conf_path, "nagios.cfg"),
             source="salt://nagios/files/nagios.cfg.tpl",
             template="jinja",
             mode="644",
             user=p_user
             group=p_group,
             require=[File(conf_path)])
    
File.managed(path.join(conf_path, "resource.cfg"),
             source="salt://nagios/files/resource.cfg.tpl",
             template="jinja",
             mode="600",
             user=p_user,
             group=p_group,
             require=[File(conf_path)])

File.managed(identity_path, 
             source="salt://ssl/openssh-privkey.tpl",
             template="jinja",
             context={"privkey_key": "nagios-objects-access"},
             mode="600",
             user="root",
             group="root")

File.directory(
  objects_path,
  create=False,
  user=p_user,
  group=p_group,
  file_mode="640",
  dir_mode="750",
  recurse=["user", "group", "mode"],
  require=[Git(objects_path)])

Git.latest(
  objects_path,
  name=objects_remote_uri,
  target=objects_path.rstrip('/'),
  rev="master",
  force_clone=True,
  force_checkout=True,
  identity=identity_path,
  require=[File(identity_path), File(conf_path)])

File.managed(
  path.join(nagios_home, ".ssh/config"),
  source="salt://nagios/files/ssh-config",
  mode="750",
  user=p_user,
  group=p_group,
  require=[User(p_user)])

File.managed(
  path.join(nagios_home, ".ssh/nagios-hosts-access-key"),
  source="salt://ssl/openssh-privkey.tpl",
  template="jinja",
  context={"privkey_key": "nagios-hosts-access"},
  mode="600",
  user=p_user,
  group=p_group,
  require=[User(p_user)])

File.managed(var_path,
             create=True,
             mode="0755"
             user=p_user,
             group=p_group,
             require=[User(p_user)])

File.directory(path.join(var_path, "rw/"),
               create=True,
               mode="6755",
               user=p_user,
               group=p_group,
               require=[File(var_path)])

File.directory(spool_path,
               create=True,
               mode="0750",
               user=p_user,
               group=p_group,
               require=[File(var_path)])

File.directory(path.join(spool_path, "checkresults/"),
               create=True,
               mode="0750",
               user=p_user,
               group=p_group,
               require=[File(spool_path)])

File.directory(archives_path,
               create=True,
               mode="0750",
               user=p_user,
               group=p_group,
               require=[File(var_path)])

File.directory(
  pki_path, create=True,
  mode=700, user=p_user, group="root",
  require=[File("/etc/pki/")])

for k in p_extra_vault_states.keys():
  cert_key_expiration_state(
        "nagios", "nagios:vault-"+ k, "pki/nagios", "nagios-"+ k,
        "nagios:user", p_user, "nagios:group", p_group,
        require_list=[User(p_user)],
        watch_in_list=[Service("nagios-reload")],
        manage_directory=False,
        fullchain_filename= k +"_fullchain.pem",
        privkey_filename= k +"_privkey.pem",
        ca_chain_filename= k + "_ca_chain",
        expiration_filename= k +"_expiration")

g_os = grains("os")
g_os_family = grains("os_family")
service_name = ("nagios" if g_os_family == "Gentoo"
                else "nagios4" if g_os_family == "Debian"
                else "nagios")

Service.running(
  "nagios",
  name=service_name,
  enable=True,
  watch=[
    Pkg(nagios_pkg),
    User(p_user),
    File(conf_path),
    File(path.join(conf_path, "nagios.cfg")),
    File(var_path),
    File(path.join(var_path, "rw/")),
    File(spool_path),
    File(path.join(spool_path, "checkresults/")),
    File(archives_path)])

# This is for watch_in reloads
Service.running(
  "nagios-reload",
  name=service_name,
  reload=True,
  watch=[Git(objects_path),
         File(path.join(conf_path, "resource.cfg"))])
