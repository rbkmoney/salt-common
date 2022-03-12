include:
  - .repo-ubuntu

pkg_salt-minion:
  pkg.latest:
    - name: salt-minion
    - require:
      - pkgrepo: salt-repo
      - file: /usr/share/keyrings/salt-archive-keyring.gpg
