include:
  - .repo-ubuntu

pkg_salt-minion:
  pkg.latest:
    - name: salt-minion
    - require:
      - file: /etc/apt/sources.list.d/salt.list
      - file: /usr/share/keyrings/salt-archive-keyring.gpg
