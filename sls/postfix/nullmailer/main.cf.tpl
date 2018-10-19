{% set mydomain = salt['pillar.get']('postfix:nullmailer:mydomain') %}
{% set relayhost = salt['pillar.get']('postfix:nullmailer:relayhost') %}
queue_directory = /var/spool/postfix
command_directory = /usr/sbin
daemon_directory = /usr/libexec/postfix
data_directory = /var/lib/postfix
sendmail_path = /usr/sbin/sendmail
newaliases_path = /usr/bin/newaliases
mailq_path = /usr/bin/mailq
html_directory = no
manpage_directory = /usr/share/man
sample_directory = /etc/postfix
readme_directory = no

mail_owner = postfix
default_privs = nobody
setgid_group = postdrop

#myhostname = host.domain.tld
mydomain = {{ mydomain }}

myorigin = $myhostname
#myorigin = $mydomain

inet_protocols = ipv6, ipv4
inet_interfaces = localhost
#mydestination = $myhostname, localhost
mynetworks_style = host

unknown_local_recipient_reject_code = 550

#relay_domains = $mydomain
relayhost = {{ relayhost }}
smtpd_relay_restrictions = permit_mynetworks, reject_unauth_destination

#fast_flush_domains = $relay_domains

#default_destination_concurrency_limit = 20
home_mailbox = .maildir/
