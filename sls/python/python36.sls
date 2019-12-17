include:
  - gentoo.makeconf

python36:
  pkg.installed:
    - pkgs:
      - dev-lang/python: "{{ salt.pillar.get('gentoo:portage:python36:version') }}"
    - slot: '3.6'
    - watch:
      - augeas: manage-make-conf
