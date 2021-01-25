server {
    include listen;
{% if ssl %}
    include listen_ssl;
    ssl_certificate {{ ssl_cert_path }};
    ssl_certificate_key {{ ssl_key_path }};
{% endif %}
    server_name {{ server_name }};
    
    include includes/errors.conf;
    
    autoindex on;
    gzip_static on;
    root {{ document_root }};
}
