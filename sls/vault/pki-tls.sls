#!pyobjects
# -*- mode: python -*-
import os, time

from salt://ssl/pki-vault.sls import cert_key_expiration_state
include('ssl.dirs')

minion_id = grains("id")
vault_pki = pillar("vault:pki", {})
vault_user = pillar("vault:user", "vault")
vault_group = pillar("vault:group", "vault")
conf_dir = "/etc/vault/"
pki_dir = "/etc/pki/vault/"
expiration_file = pki_dir + "expiration"


cert_key_expiration_state("vault", "vault:pki", "pki_vault", "vault-listener",
                          "vault:user", "vault", "vault:group", "vault")

ca_chain_state("vault", "vault:pki", "pki_vault",
               "vault:user", "vault", "vault:group", "vault")
