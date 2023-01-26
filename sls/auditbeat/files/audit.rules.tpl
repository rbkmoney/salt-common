## Managed by Salt
## -*- mode: shell-script -*-

## This rule suppresses the time-change event when chrony does time updates
-a never,exit -F arch=b64 -S adjtimex -F auid=unset -F uid=root

# This rule supresses events that originate on the below file systems.
# Typically you would use this in conjunction with rules to monitor
# kernel modules. The filesystem listed are known to cause hundreds of
# path records during kernel module load. As an aside, if you do see the
# tracefs or debugfs module load and this is a production system, you really
# should look into why its getting loaded and prevent it if possible.
# -a never,filesystem -F fstype=tracefs
# -a never,filesystem -F fstype=debugfs

## The purpose of these rules is to meet the pci-dss v3.1 auditing requirements
## NOTE:
## If these rules generate too much spurious data for your tastes, limit the
## the syscall file rules with a directory, like -F dir=/etc
## You can search for the results on the key fields in the rules

## 10.1 Implement audit trails to link all access to individual user.
##  This requirement is implicitly met 

## 10.2.1 Implement audit trails to detect user accesses to cardholder data
## This would require a watch on the database that excludes the daemon's
## access. This rule is commented out due to needing a path name
#-a always,exit -F path=/var/lib/riak -F auid>=1000 -F auid!=unset -F uid!=riak -F perm=r -F key=10.2.1-cardholder-access

## 10.2.2 Log administrative action.
-a exit,always -F arch=b64 -F auid!=unset -S execve{% if salt['user.info']('consul') %} -F auid!=consul{% endif %} -F key=10.2.2-actions

## 10.2.3 Access to all audit trails.
-a always,exit -F dir=/var/log/audit/ -F perm=r -F auid>=1000 -F auid!=unset -F key=10.2.3-access-audit-trail
-a always,exit -F path=/sbin/ausearch -F perm=x -F key=10.2.3-access-audit-trail
-a always,exit -F path=/sbin/aureport -F perm=x -F key=10.2.3-access-audit-trail
-a always,exit -F path=/usr/bin/aulast -F perm=x -F key=10.2.3-access-audit-trail
-a always,exit -F path=/usr/bin/aulastlog -F perm=x -F key=10.2.3-access-audit-trail
-a always,exit -F path=/usr/bin/auvirt -F perm=x -F key=10.2.3-access-audit-trail

## 10.2.4 Invalid logical access attempts. This is naturally met by pam. You
## can find these events with: ausearch --start today -m user_login -sv no -i

## 10.2.5.a Use of I&A mechanisms is logged. Pam naturally handles this.
## you can find the events with:
##   ausearch --start today -m user_auth,user_chauthtok -i

## 10.2.5.b All elevation of privileges is logged
-a always,exit -F arch=b64 -S setuid -F a0=0 -F exe=/usr/bin/su -F key=10.2.5.b-elevated-privs-session
-a always,exit -F arch=b32 -S setuid -F a0=0 -F exe=/usr/bin/su -F key=10.2.5.b-elevated-privs-session
-a always,exit -F arch=b64 -S setresuid -F a0=0 -F exe=/usr/bin/sudo -F key=10.2.5.b-elevated-privs-session{% if salt['user.info']('nagios') %} -F auid!=nagios{% endif %}{% if salt['user.info']('consul') %} -F auid!=consul{% endif %} 
-a always,exit -F arch=b32 -S setresuid -F a0=0 -F exe=/usr/bin/sudo -F key=10.2.5.b-elevated-privs-session
-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -F key=10.2.5.b-elevated-privs-setuid{% if salt['user.info']('nagios') %} -F auid!=nagios{% endif %}{% if salt['user.info']('consul') %} -F auid!=consul{% endif %} 
-a always,exit -F arch=b32 -S execve -C uid!=euid -F euid=0 -F key=10.2.5.b-elevated-privs-setuid

## 10.2.5.c All changes, additions, or deletions to any account are logged
## This is implicitly covered by shadow-utils. We will place some rules
## in case someone tries to hand edit the trusted databases
-a always,exit -F path=/etc/group -F perm=wa -F key=10.2.5.c-accounts
-a always,exit -F path=/etc/passwd -F perm=wa -F key=10.2.5.c-accounts
-a always,exit -F path=/etc/gshadow -F perm=wa -F key=10.2.5.c-accounts
-a always,exit -F path=/etc/shadow -F perm=wa -F key=10.2.5.c-accounts
-a always,exit -F path=/etc/security/opasswd -F perm=wa -F key=10.2.5.c-accounts

## 10.2.6 Verify the following are logged:
## Initialization of audit logs
## Stopping or pausing of audit logs.
## These are handled implicitly by auditd

## 10.2.7 Creation and deletion of system-level objects
## This requirement seems to be database table related and not audit

## 10.3 Record at least the following audit trail entries
## 10.3.1 through 10.3.6 are implicitly met by the audit system.

## 10.4.2b Time data is protected.
## We will place rules to check time synchronization
-a always,exit -F arch=b32 -S adjtimex,settimeofday,stime -F key=10.4.2b-time-change
-a always,exit -F arch=b64 -S adjtimex,settimeofday -F key=10.4.2b-time-change
-a always,exit -F arch=b32 -S clock_settime -F a0=0x0 -F key=10.4.2b-time-change
-a always,exit -F arch=b64 -S clock_settime -F a0=0x0 -F key=10.4.2b-time-change
-w /etc/localtime -p wa -k 10.4.2b-time-change
-w /etc/timezone -p wa -k 10.4.2b-time-change

## 10.5 Secure audit trails so they cannot be altered
## 10.5.1 Limit viewing of audit trails to those with a job-related need.
## 10.5.2 Protect audit trail files from unauthorized modifications.
## 10.5.3 Promptly back up audit trail files to a centralized log server
## 10.5.4 Write logs for external-facing technologies onto a secure log server
## The audit system protects audit logs by virtue of being the root user,
## and, by default, limits viewing of the auit trail to root.
## That means that no normal user can tamper with the audit trail.
## Audit logs are parsed and forwared to ElasticSearch for storage and analytics

## 10.5.5 Use file-integrity monitoring or change-detection software on logs
-a always,exit -F dir=/var/log/audit/ -F perm=wa -F key=10.5.5-modification-audit-logs
#-a always,exit -F dir=/var/log/auditbeat/ -F perm=wa -F key=10.5.5-modification-auditbeat-logs
#-a always,exit -F dir=/var/log/filebeat/ -F perm=wa -F key=10.5.5-modification-filebeat-logs

## Watches on other critical logs
-a always,exit -F dir=/var/log/salt/ -F perm=wa -F key=10.5.5-modification-salt-logs

## Use these rules if you want to log container events
## watch for container creation
-a always,exit -F arch=b32 -S clone -F a0&0x7C020000 -F key=container-create
-a always,exit -F arch=b64 -S clone -F a0&0x7C020000 -F key=container-create

## watch for containers that may change their configuration
-a always,exit -F arch=b32 -S unshare,setns -F key=container-config
-a always,exit -F arch=b64 -S unshare,setns -F key=container-config

## These rules watch for code injection by the ptrace facility.
## This could indicate someone trying to do something bad or
## just debugging

#-a always,exit -F arch=b32 -S ptrace -F key=tracing
-a always,exit -F arch=b64 -S ptrace -F key=tracing
-a always,exit -F arch=b32 -S ptrace -F a0=0x4 -F key=code-injection
-a always,exit -F arch=b64 -S ptrace -F a0=0x4 -F key=code-injection
-a always,exit -F arch=b32 -S ptrace -F a0=0x5 -F key=data-injection
-a always,exit -F arch=b64 -S ptrace -F a0=0x5 -F key=data-injection
-a always,exit -F arch=b32 -S ptrace -F a0=0x6 -F key=register-injection
-a always,exit -F arch=b64 -S ptrace -F a0=0x6 -F key=register-injection

## These rules watch for kernel module insertion
-w /sbin/kmod -p x -k modules
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-a always,exit -F arch=b32 -S init_module,finit_module -F key=module-load
-a always,exit -F arch=b64 -S init_module,finit_module -F key=module-load
-a always,exit -F arch=b32 -S delete_module -F key=module-unload
-a always,exit -F arch=b64 -S delete_module -F key=module-unload

