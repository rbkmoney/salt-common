# This file is generated by Salt
-----BEGIN PRIVATE KEY-----
{{ salt['pillar.get']('pki:tls:'+privkey_key+':privkey').rstrip('\n') }}
-----END PRIVATE KEY-----
