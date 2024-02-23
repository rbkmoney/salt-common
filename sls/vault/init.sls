include:
  - .service
  - .pkg
  - .pki-tls

extend:
  vault:
    service.running:
      - watch:
        - pkg: app-admin/vault
  /etc/vault.d/:
    file.directory:
      - require:
        - pkg: app-admin/vault
