# Managed by Salt
# see man pages for salt-minion or run `salt-master --help`
# for valid cmdline options
SALT_OPTS="{{ salt_opts }}"

rc_ulimit="-n {{ l_nofile }} -u {{ l_nproc }}"
