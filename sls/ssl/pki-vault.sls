#!pyobjects
# -*- mode: python -*-
import time
from os import path

minion_id = grains("id")
pki_rdir = "/etc/pki/"

def list_or_str(l, delim=","):
  if isinstance(l, list):
    return delim.join(l)
  elif isinstance(l, str):
    return l
  raise KeyError("Not list or string")

def cert_key_expiration_state(
    pki_dname, vault_pillar, pki_path_default, role_default,
    user_pillar, user_default, group_pillar, group_default,
    SANs=[], IP_SANs=[], CN=minion_id, ttl_default="72h",
    renew_threshold_default=86400):
  '''
  This function creates File.directory states for pki_dir,
  File.managed states for fullchain, cert, ca_chain,
  expiration files, checks for file presense and expiration,
  and requests new certificates if needed.
  Vault pillar keys example:
  enabled: True # Defaults to False
  pki-path: "pki/prod/foo"
  pki-role: "foo"
  ttl: "72h"
  renew-threshold: 86400
  CN: "foo.bar.com"
  SANs: ["foo.bar.com"]
  IP_SANs: ["1.2.3.4"]
  '''
  p_vault = pillar(vault_pillar, {})
  user = pillar(user_pillar, user_default)
  group = pillar(group_pillar, group_default)
  pki_dir = path.join(pki_rdir, pki_dname,)
  if not pki_dir.endswith("/"):
    pki_dir += "/"
  fullchain_file = pki_dir + "fullchain.pem"
  privkey_file = pki_dir + "privkey.pem"
  ca_chain_file = pki_dir + "ca_chain.pem"
  expiration_file = pki_dir + "expiration"
  _CN = p_vault.get('CN', CN)
  _SANs = list_or_str(p_vault.get('SANs', SANs))
  _IP_SANs = list_or_str(p_vault.get('IP_SANs', IP_SANs))

  File.directory(
    pki_dir, create=True,
    mode=755, user="root", group="root",
    require=[File(pki_rdir)])

  if p_vault.get('enable', False):
    pki_path = p_vault.get("pki-path", pki_path_default)
    pki_role = p_vault.get("pki-role", role_default)
    ttl = p_vault.get("ttl", "72h")
    min_remains = p_vault.get("renew-threshold", 86400)
    remaining = 0

    if path.isfile(expiration_file):
      with open(expiration_file, 'rb') as f:
        try:
          remaining = int(f.read(20)) - time.time()
        except ValueError:
          pass

    if (remaining <= min_remains
        or not path.isfile(fullchain_file)
        or not path.isfile(privkey_file)
        or not path.isfile(ca_chain_file)
        or not path.isfile(expiration_file)):
      cert_data = salt.vault.write_secret(
        "{0}/issue/{1}".format(pki_path, pki_role),
        common_name=_CN, alt_names=_SANs,
        ip_sans=_IP_SANs,
        private_key_format="pkcs8", ttl=ttl)
      if not cert_data:
        raise KeyError("Unable to issue the certificate from Vault")

      File.managed(
        fullchain_file,
        mode=644, user=user, group=group,
        contents='\n'.join(
          ("# Managed by Salt",
           cert_data["certificate"],
           cert_data["issuing_ca"])),
        require=[File(pki_dir)])

      File.managed(
        privkey_file,
        mode=600, user=user, group=group,
        contents='\n'.join(("# Managed by Salt", cert_data["private_key"])),
        require=[File(pki_dir)])

      File.managed(
        expiration_file,
        mode=644, user="root", group="root",
        contents=cert_data["expiration"],
        require=[File(pki_dir)])
    else:
      File.managed(
        fullchain_file, create=False, replace=False,
        mode=644, user=user, group=group,
        require=[File(pki_dir)])

      File.managed(
        privkey_file, create=False, replace=False,
        mode=600, user=user, group=group,
        require=[File(pki_dir)])

      File.managed(
        expiration_file, create=False, replace=False,
        mode=644, user="root", group="root",
        require=[File(pki_dir)])

    ca_data = salt.vault.read_secret(
      "{0}/cert/ca_chain".format(pki_path))
    if not ca_data or not "ca_chain" in ca_data:
      raise KeyError("Unable to get CA chain from Vault")
    ca_chain = ca_data["ca_chain"]

    File.managed(
      ca_chain_file, mode=644, user=user, group=group,
      contents=("# Managed by Salt\n" +
        ('\n'.join(ca_chain) if type(ca_chain) == list else ca_chain)),
      require=[File(pki_dir)])

def ca_chain_state(
    pki_dname, vault_pillar, pki_path_default,
    user_pillar, user_default, group_pillar, group_default):
  '''
  This function creates File.directory states for pki_dir,
  File.managed state for ca_chain and requests new chain.
  Vault pillar keys example:
  enabled: True # Defaults to False
  pki-path: "pki/prod/foo"
  '''
  p_vault = pillar(vault_pillar, {})
  user = pillar(user_pillar, user_default)
  group = pillar(group_pillar, group_default)
  pki_dir = path.join(pki_rdir, pki_dname)
  if not pki_dir.endswith("/"):
    pki_dir += "/"
  ca_chain_file = pki_dir + "ca_chain.pem"

  File.directory(
    pki_dir, create=True,
    mode=755, user="root", group="root",
    require=[File(pki_rdir)])

  if p_vault.get('enable', False):
    pki_path = p_vault.get("pki-path", pki_path_default)

    ca_data = salt.vault.read_secret(
      "{0}/cert/ca_chain".format(pki_path))
    if not ca_data or not "ca_chain" in ca_data:
      raise KeyError("Unable to get CA chain from Vault")
    ca_chain = ca_data["ca_chain"]

    File.managed(
      ca_chain_file, mode=644, user=user, group=group,
      contents=(
        "# Managed by Salt\n" +
        ('\n'.join(ca_chain) if type(ca_chain) == list else ca_chain)),
      require=[File(pki_dir)])
