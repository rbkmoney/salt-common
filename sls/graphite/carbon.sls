include:
  - gentoo.makeconf

dev-python/carbon:
  pkg.installed:
    - version: ">=1.1.3-r1"
    - require:
      - augeas: manage-make-conf
