locale:
  eselect.set:
    - target: {{ salt.pillar.get('locale:LANG','en_IE.utf8') }}

/etc/env.d/02locale:
  augeas.change:
    - context: /files/etc/env.d/02locale
    - lens: Shellvars.lns
    - changes:
      - set LC_TIME "{{ salt.pillar.get('locale:LC_TIME','en_IE.UTF-8') }}"
      - set LC_ALL "{{ salt.pillar.get('locale:LC_ALL','en_IE.UTF-8') }}"
