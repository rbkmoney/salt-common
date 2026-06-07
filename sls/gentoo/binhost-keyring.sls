{% set p_binhost = salt.pillar.get('gentoo:binhost', {}) %}
{% set key_fingerprint = p_binhost.get('key-fingerprint', 'A18A4922C89EFC3188558873E3506766BD71FBE9') %}
{% set key_file = p_binhost.get('key-file', 'salt://gentoo/files/baka-bakka-amd64-binhost.pgp') %}
{% set gpg_homedir = '/etc/portage/gnupg' %}
{% set passphrase_file = p_binhost.get('passphrase-file', '/etc/portage/gnupg/pass') %}
{% set local_key_passphrase = p_binhost.get('local-key-passphrase', False) %}

# Portage GPG keyring for binary package repository verification
# Requires app-crypt/gnupg and app-crypt/pinentry

/etc/portage/gnupg/:
  file.directory:
    - create: True
    - mode: 755
    - user: portage
    - group: portage
    - recurse:
      - user
      - group

/etc/portage/gnupg/gpg-agent.conf:
  file.managed:
    - contents: |
        allow-preset-passphrase
        max-cache-ttl 34560000
        default-cache-ttl 34560000
    - mode: 644
    - user: portage
    - group: portage
    - require:
      - file: /etc/portage/gnupg/

/etc/portage/gnupg/binhost-key.pgp:
  file.managed:
    - source: {{ key_file }}
    - mode: 644
    - user: portage
    - group: portage
    - require:
      - file: /etc/portage/gnupg/

/etc/portage/gnupg/pass:
  file.managed:
    {% if local_key_passphrase %}
    - contents: {{ local_key_passphrase }}
    {% else %}
    - replace: False
    {% endif %}
    - show_changes: False
    - mode: 600
    - user: portage
    - group: portage
    - require:
      - file: /etc/portage/gnupg/

binhost-key-import:
  gpg_ext.import_key:
    - filename: /etc/portage/gnupg/binhost-key.pgp
    - gnupghome: {{ gpg_homedir }}
    - require:
      - file: /etc/portage/gnupg/binhost-key.pgp

binhost-key-sign-and-trust:
  gpg_ext.sign_key:
    - fingerprint: {{ key_fingerprint }}
    - gnupghome: {{ gpg_homedir }}
    - passphrase_file: {{ passphrase_file }}
    - trust: fully
    - require:
      - gpg_ext: binhost-key-import
      - file: /etc/portage/gnupg/pass
