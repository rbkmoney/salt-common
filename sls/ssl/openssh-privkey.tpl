{% set key_type = privkey_type if privkey_type is defined else 'OPENSSH' -%}
-----BEGIN {{ key_type }} PRIVATE KEY-----
{{ salt['pillar.get']('pki:openssh:'+privkey_key+':privkey').rstrip('\n') }}
-----END {{ key_type }} PRIVATE KEY-----
