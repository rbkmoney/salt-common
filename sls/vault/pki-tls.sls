#!pyobjects
# -*- mode: python -*-
import os, time

from salt://ssl/pki-vault.sls import cert_key_expiration_state
include('ssl.dirs')

cert_key_expiration_state("vault", "vault:pki", "pki_vault", "vault-listener",
                          "vault:user", "vault", "vault:group", "vault",
                          IP_SANs=["::1"])
