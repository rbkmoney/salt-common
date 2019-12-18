include:
  - gentoo.makeconf

python2:
  pkg.installed:
    - pkgs:
      - dev-lang/python: "{{ salt.pillar.get('gentoo:portage:python27:version') }}"
    - slot: '2.7'
    - watch:
      - augeas: manage-make-conf
