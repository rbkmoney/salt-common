# -*- mode: nginx -*-
# Managed by Salt
server {
        listen 80 default;
        listen [::]:80 default ipv6only=on;
        listen 443 default ssl;
        listen [::]:443 default ssl ipv6only=on;
        server_name default;

        ssl_certificate /etc/ssl/nginx/nginx.pem;
        ssl_certificate_key /etc/ssl/nginx/nginx.key;
        root /var/www/default/htdocs;
}
