include:
  - gentoo.makeconf

dev-python/carbon:
  pkg.installed:
    - pkgs:
      - dev-python/carbon: "~>=1.1.5"
      - dev-python/whisper: "~>=1.1.5"
    - require:
      - augeas: manage-make-conf
