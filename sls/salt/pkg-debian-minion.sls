include:
  - .repo-debian

pkg_salt-minion:
  pkg.latest:
    - name: salt-minion
    - refresh: True
    - require:
      - file: /etc/apt/sources.list.d/salt.list
