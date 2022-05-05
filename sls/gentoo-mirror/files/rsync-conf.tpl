# -*- mode: shell-script -*-
{% set default_rsync_opts = "--quiet --recursive --links --hard-links --perms --chmod D755,F644 --times --devices --delete --timeout=300" %}
{% if rsync_binary is not defined %}
# Using default rsync binary location
RSYNC="/usr/bin/rsync"
{% else %}
# Using custom rsync binary location
RSYNC="{{ rsync_binary }}"
{% endif %}
{% if rsync_opts is not defined %}
# Using default rsync options
OPTS="{{ default_rsync_opts }}"
{% else %}
# Using custom rsync options
{% if rsync_opts.startswith('+') %}
{% set rsync_opts = default_rsync_opts+rsync_opts[1:] %}
{% endif %}
OPTS="{{ rsync_opts }}"
{% endif %}
SRC="{{ rsync_src }}"
DST="{{ rsync_dst }}"
