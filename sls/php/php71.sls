php:
  pkg.installed:
    - pkgs:
      - dev-lang/php: ":7.1[fpm,embed,cli,curl,bcmath,gd,inifile,mysql,mysqli,pcntl,pdo,sqlite,snmp,sysvipc,xmlrpc,xmlreader,xmlwriter,xslt]"
      - app-eselect/eselect-php: ">=0.9.4[fpm]"
      - virtual/httpd-php: ":7.1"
