user nginx nginx;
worker_processes {{ worker_processes }};
worker_rlimit_nofile {{ worker_rlimit_nofile }};
events {
    worker_connections {{ worker_connections }};
    use epoll;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format common '[$time_local] $http_host $remote_addr $remote_user'
    ' "$request" [$status] $upstream_cache_status $bytes_sent $request_time'
    ' "$http_referer" "$http_user_agent" "$http_cookie"';

    access_log /var/log/nginx/access_log common;
    error_log /var/log/nginx/error_log info;

    client_header_timeout 10m;
    client_body_timeout 10m;
    send_timeout 10m;

    connection_pool_size 256;
    client_header_buffer_size 1k;
    large_client_header_buffers 4 2k;
    request_pool_size 4k;

    gzip on;
    gzip_min_length 1100;
    gzip_buffers 4 8k;
    gzip_types text/plain;

    output_buffers 1 32k;
    postpone_output 1460;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;

    keepalive_timeout 75 20;

    ignore_invalid_headers on;
    server_tokens off;

    ssl_protocols {{ ssl_protocols }};
    ssl_prefer_server_ciphers on;
    ssl_ciphers {{ ssl_ciphers }};
    ssl_ecdh_curve {{ ssl_ecdh_curve }};
    ssl_session_cache {{ ssl_session_cache }};
    ssl_session_timeout {{ ssl_session_timeout }};
    ssl_session_tickets on;

    map  $ssl_client_s_dn  $ssl_client_s_dn_cn {
    	 default "";
	 ~[/,]?CN=(?<CN>[^/,]+) $CN;
    }

    log_format tls_client '[$time_local] $http_host $remote_addr $ssl_client_s_dn_cn'
    ' "$request" [$status] $upstream_cache_status $bytes_sent $request_time'
    ' "$http_referer" "$http_user_agent" "$http_cookie"';

    include /etc/nginx/vhosts.d/*.conf;
}

