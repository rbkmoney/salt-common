#!jinja|yaml
# -*- mode: conf -*-
# Managed by Salt
{%- macro op_pillar(option, default) %}
{{ option }} {{ salt.pillar.get('ssh:sshd_config:' + option, default) }}
{%- endmacro %}

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.
Protocol 2

{{ op_pillar('Port', '22') }}
{{ op_pillar('AddressFamily', 'any') }}
{% if grains['os'] == 'Gentoo' %}
{{ op_pillar('Transport', 'TCP') }}
{% endif %}
{{ op_pillar('SyslogFacility', 'AUTH') }}
{{ op_pillar('LogLevel', 'INFO') }}

# Authentication
{{ op_pillar('LoginGraceTime', '2m') }}
{{ op_pillar('StrictModes', 'yes') }}
{{ op_pillar('MaxAuthTries', '3') }}
{{ op_pillar('MaxStartups', '10:30:100') }}
{{ op_pillar('MaxSessions', '100') }}

{{ op_pillar('PubkeyAuthentication', 'yes') }}

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile .ssh/authorized_keys

{{ op_pillar('HostbasedAuthentication', 'no') }}
# Change to yes if you don't trust ~/.ssh/known_hosts for
# RhostsRSAAuthentication and HostbasedAuthentication
{{ op_pillar('IgnoreUserKnownHosts', 'no') }}

{{ op_pillar('IgnoreRhosts', 'yes') }}

# To disable tunneled clear text passwords, change to no here!
{{ op_pillar('PasswordAuthentication', 'no') }}
{{ op_pillar('PermitEmptyPasswords', 'no') }}
{{ op_pillar('PermitRootLogin', 'without-password') }}

# Change to no to disable s/key passwords
{{ op_pillar('ChallengeResponseAuthentication', 'yes') }}

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
{{ op_pillar('UsePAM', 'no') }}

{{ op_pillar('AuthenticationMethods', 'any') }}

{{ op_pillar('AllowAgentForwarding', 'yes') }}
{{ op_pillar('AllowTcpForwarding', 'yes') }}
{{ op_pillar('GatewayPorts', 'no') }}
{{ op_pillar('X11Forwarding', 'no') }}
{{ op_pillar('PermitTTY', 'yes') }}
{{ op_pillar('PrintMotd', 'no') }}
{{ op_pillar('PrintLastLog', 'no') }}
{{ op_pillar('TCPKeepAlive', 'yes') }}
{{ op_pillar('Compression', 'delayed') }}
{{ op_pillar('ClientAliveInterval', '0') }}
{{ op_pillar('ClientAliveCountMax', '3') }}
{{ op_pillar('UseDNS', 'no') }}
{{ op_pillar('PidFile', '/run/sshd.pid') }}
{{ op_pillar('PermitTunnel', 'no') }}

# no default banner path
{{ op_pillar('Banner', 'none') }}

# override default of no subsystems
{{ op_pillar('Subsystem', 'sftp internal-sftp') }}
{% if grains['os'] == 'Gentoo' %}
# the following are HPN related configuration options
# tcp receive buffer polling. disable in non autotuning kernels
{{ op_pillar('TcpRcvBufPoll', 'yes') }}

# buffer size for hpn to non-hpn connections
{{ op_pillar('HPNBufferSize', '2048') }}
{% endif %}
# Allow client to pass locale environment variables #367017
{{ op_pillar('AcceptEnv', 'LANG LC_*') }}
{{ op_pillar('PermitUserEnvironment', 'no') }}
{{ op_pillar('Ciphers', 'aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr') }}

{% for k, v in salt.pillar.get('ssh:sshd_config:extra', {}).items() %}
{% if v is mapping %}
{{ k }}
  {% for mk, mv in v %}
  {{ mk }} {{ mv }}
  {% endfor %}
{% else %}
{{ k }} {{ v}}
{% endif %}
{% endfor %}
