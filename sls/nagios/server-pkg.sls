nagios_pkg:
  pkg.installed:
    - pkgs:
        - net-analyzer/nagios-core: "4.2.2[web,perl]"
        - app-emacs/nagios-mode
