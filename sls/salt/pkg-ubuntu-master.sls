include:
  - .repo-ubuntu

pkg_salt-master:
  pkg.latest:
    - name: salt-master
    - refresh: True
    - require:
      - file: /etc/apt/sources.list.d/salt.list
