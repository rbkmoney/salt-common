# -*- mode: yaml -*-
include:
  - gentoo.repos.baka-bakka

riak_nagios_pkg:
  pkg.installed:
    - pkgs:
      - net-analyzer/riak_nagios: "~>=9998-r1"
