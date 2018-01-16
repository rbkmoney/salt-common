include:
  - ssl.openssl

erlang:
  pkg.installed:
    - pkgs:
      - dev-lang/erlang: "~20.2[smp,hipe,kpoll,sctp,odbc]"
