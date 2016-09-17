# -*- mode: yaml -*-
include:
  - gitolite

gentoo-sync:
  cron.present:
    - identifier: gentoo-sync
    - name: 'gitolite ../triggers/upstream fetch gentoo'
    - hour: '*/4'
    - minute: '0'
    - user: git
    - require:
      - pkg: dev-vcs/gitolite

gentoo-mirror-sync:
  cron.present:
    - identifier: gentoo-mirror-sync
    - name: 'gitolite ../triggers/upstream fetch gentoo-mirror'
    - hour: '*/4'
    - minute: '0'
    - user: git
    - require:
      - pkg: dev-vcs/gitolite
