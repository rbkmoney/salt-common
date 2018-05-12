include:
  - lib.gd

nagios_pkg:
  pkg.installed:
    - pkgs:
        - net-analyzer/nagios-core: "~>=4.2.2[web,perl]"
    - require:
      - pkg: media-libs/gd
