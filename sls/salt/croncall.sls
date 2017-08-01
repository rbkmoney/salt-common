include:
  - cron

salt-call:
  cron.present:
    - identifier: salt-call
    - name: PATH='/usr/sbin:/usr/bin:/sbin:/bin' salt-call -l warning --out=quiet state.highstate
    - hour: '6'
    - minute: '0'
    - user: root
