include:
  - openssl

erlang:
  pkg.installed:
    - pkgs:
      - dev-lang/erlang: ">=19.1[smp,hipe,kpoll,sctp,odbc]"
