[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=forking
PIDFile=/run/php-fpm.pid
ExecStart=/bin/sh -c '/usr/bin/php-fpm -g /run/php-fpm.pid -y /etc/php/fpm-$(eselect php show fpm)/php-fpm.conf'
ExecReload=/bin/kill -USR2 $MAINPID
ExecStop=/bin/kill $MAINPID

[Install]
WantedBy=multi-user.target