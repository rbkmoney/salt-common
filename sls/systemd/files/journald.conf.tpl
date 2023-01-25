# Managed by Salt
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.
#
# Entries in this file show the compile time defaults.
# You can change settings by editing this file.
# Defaults can be restored by simply deleting this file.
#
# See journald.conf(5) for details.
{%- set conf = salt.pillar.get('systemd:journald:conf', {}) %}

[Journal]
Storage={{ conf.get('Storage', "auto") }}
Compress={{ conf.get("Compress", "yes") }}
Seal={{ conf.get("Seal", "yes") }}
SplitMode={{ conf.get("SplitMode", "uid") }}
ReadKMsg={{ conf.get('ReadKMsg', "yes") }}
ForwardToSyslog={{ conf.get('ForwardToSyslog', "yes") }}
ForwardToKMsg={{ conf.get('ForwardToKMsg', "no") }}
ForwardToConsole={{ conf.get('ForwardToConsole', "no") }}
ForwardToWall={{ conf.get('ForwardToWall', "no") }}
MaxLevelStore={{ conf.get('MaxLevelStore', "debug") }}
MaxLevelSyslog={{ conf.get('MaxLevelSyslog', "debug") }}
MaxLevelKMsg={{ conf.get('MaxLevelKMsg', "debug") }}
MaxLevelConsole={{ conf.get('MaxLevelConsole', "info") }}
MaxLevelWall={{ conf.get("MaxLevelWall", "emerg") }}

SyncIntervalSec={{ conf.get("SyncIntervalSec", "5m") }}
RateLimitIntervalSec={{ conf.get("RateLimitIntervalSec", "30s") }}
RateLimitBurst={{ conf.get("RateLimitBurst", "10000") }}
{% if "SystemMaxUse" in conf -%}
SystemMaxUse={{ conf["SystemMaxUse"] }}
{%- endif %}
{% if "SystemKeepFree" in conf -%}
SystemKeepFree={{ conf["SystemKeepFree"] }}
{%- endif %}
{% if "SystemMaxFileSize" in conf -%}
SystemMaxFileSize={{ conf["SystemMaxFileSize"] }}
{%- endif %}
SystemMaxFiles={{ conf.get("SystemMaxFiles", "100") }}
{% if "RuntimeMaxUse" in conf -%}
RuntimeMaxUse={{ conf["RuntimeMaxUse"] }}
{%- endif %}
{% if "RuntimeKeepFree" in conf -%}
RuntimeKeepFree={{ conf["RuntimeKeepFree"] }}
{%- endif %}
{% if "RuntimeMaxFileSize" in conf -%}
RuntimeMaxFileSize={{ conf["RuntimeMaxFileSize"] }}
{%- endif %}
RuntimeMaxFiles={{ conf.get("RuntimeMaxFiles", "100") }}

MaxRetentionSec={{ conf.get("MaxRetentionSec", "1month") }}
MaxFileSec={{ conf.get("MaxFileSec", "1month") }}
TTYPath={{ conf.get("TTYPath", "/dev/console") }}
LineMax={{ conf.get("LineMax", "48K") }}
