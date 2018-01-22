nagios_pkg:
  pkg.installed:
    - pkgs:
        - net-analyzer/nagios-core: "~>=4.2.2[web,perl]"
        - media-libs/gd: ">=2.2.3[jpeg,png]"
