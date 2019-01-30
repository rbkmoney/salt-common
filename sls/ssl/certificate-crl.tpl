{% for cert in salt['pillar.get']('pki:tls:'+crl_key+':crl') %}
-----BEGIN X509 CRL-----
{{ cert.rstrip('\n') }}
-----END X509 CRL-----
{% endfor %}
