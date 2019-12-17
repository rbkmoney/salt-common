include:
  - gentoo.makeconf

python35:
  pkg.installed:
    - pkgs:
      - dev-lang/python: "{{ salt.pillar.get('gentoo:portage:python35:version') }}"
    - slot: '3.5'
    - watch:
      - augeas: manage-make-conf
