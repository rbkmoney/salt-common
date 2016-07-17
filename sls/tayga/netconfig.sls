# Should I use here pydsl? Augeas is not an option (yet) because of preup/postdown scripts.
# netifrc module for mktun && rmtun would be great.
append-nat64-config:
  file.whatever:
    - name: /etc/conf.d/net
    - content: ...
