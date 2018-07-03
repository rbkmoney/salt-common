include:
  - lib.gd

nagios_pkg:
  pkg.installed:
    - pkgs:
        - net-analyzer/nagios-core: ">=4.3.4[web,perl]"
    - require:
      - pkg: media-libs/gd
