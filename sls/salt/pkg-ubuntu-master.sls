include:
  - .repo-ubuntu

pkg_salt-master:
  pkg.latest:
    - name: salt-master
    - require:
      - file: /etc/apt/sources.list.d/salt.list
      - file: /usr/share/keyrings/salt-archive-keyring.gpg
