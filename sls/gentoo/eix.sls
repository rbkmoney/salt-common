app-portage/eix:
  pkg.latest

/var/cache/eix/:
  file.directory:
    - create: True
    - mode: 775
    - user: portage
    - group: portage
    - require_in:
      - pkg: app-portage/eix

# eix >= 0.36.7-r2 ships /etc/portage/postsync.d/50-eix-postsync: it snapshots
# portage.eix to previous.eix before eix-update (keeping eix-diff useful) and
# no-ops under eix-sync (EIX_SYNC_RUNNING), so eix-sync's own diff stays intact.
# A bare eix-update hook has no guard: it updates the db during eix-sync's
# emerge --sync, after which eix-sync copies the already-updated db to
# previous.eix and the diff is always empty.
/etc/portage/postsync.d/eix-update:
  file.absent:
    - require:
      - pkg: app-portage/eix
