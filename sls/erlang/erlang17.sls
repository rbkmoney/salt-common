include:
  - ssl.openssl

">=dev-lang/erlang-18":
  portage_config.flags:
    - mask: True

/etc/portage/env/erlang-epmd6:
  file.managed:
    - mode: 644
    - contents: |
        CPPFLAGS="${CXXFLAGS} -DEPMD6"

erlang:
  pkg.installed:
    - pkgs:
      - dev-lang/erlang: "=17.5[smp,hipe,kpoll,sctp,odbc]"
    - watch:
      - file: /etc/portage/env/erlang-epmd6
      - portage_config: erlang
  portage_config.flags:
    - env:
      - erlang-epmd6
    - require:
      - file: /etc/portage/env/erlang-epmd6
