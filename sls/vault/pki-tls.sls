#!pyobjects
# -*- mode: python -*-
import os, time

conf_dir = "/etc/vault/"
pki_dir = "/etc/pki/vault/"
expiration_file = pki_dir + "expiration"
vault_pki = pillar("vault:pki", {})
vault_user = pillar("vault:user", "vault")
vault_group = pillar("vault:group", "vault")

File.directory(
  pki_dir, create=True,
  mode=755, user="root", group="root")

if vault_pki.get('enable', False):
  v_pki_path = vault_pki.get("pki-path", "pki_vault")
  v_pki_role = vault_pki.get("pki-role", "vault-listener")
  v_ttl = vault_pki.get("ttl", "24h")
  min_remains = vault_pki.get("min_remains", 86400)
  remaining = 0

  if os.path.isfile(expiration_file):
    with open(expiration_file, 'rb') as f:
      remaining = int(f.read(20)) - time.time()

  if remaining <= min_remains:
    cert_data = salt.vault.write_secret(
      "{0}/issue/{1}".format(v_pki_path, v_pki_role),
      common_name=minion_id, private_key_format="pkcs8", ttl=v_ttl)
    if not cert_data:
      raise KeyError("Unable to issue the certificate from Vault")

    File.managed(
      pki_dir + "fullchain.pem",
      mode=644, user=vault_user, group=vault_group,
      contents='\n'.join(
        ("# Managed by Salt",
         cert_data["certificate"],
         cert_data["issuing_ca"])),
      require=[File(pki_dir)])

    File.managed(
      pki_dir + "privkey.pem",
      mode=600, user=vault_user, group=vault_group,
      contents='\n'.join(("# Managed by Salt", cert_data["private_key"])),
      require=[File(pki_dir)])

    File.managed(expiration_file,
               mode=644, user="root", group="root",
               contents=cert_data["expiration"],
               require=[File(pki_dir)])

  ca_data = salt.vault.read_secret(
    "{0}/cert/ca_chain".format(v_pki_path))
  if not ca_data or not "ca_chain" in ca_data:
    raise KeyError("Unable to get CA chain from Vault")
  ca_chain = ca_data["ca_chain"]

  File.managed(
    pki_dir + "ca_chain.pem", mode=644, user=vault_user, group=vault_group,
    contents=('\n'.join(ca_chain) if type(ca_chain) == list else ca_chain),
    require=[File(pki_dir)])
