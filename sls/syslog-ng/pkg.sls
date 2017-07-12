include:
  - logrotate

pkg_syslog-ng:
  pkg.installed:
    - pkgs:
      - app-admin/syslog-ng: ">=3.7.3[caps,pact,json]"
