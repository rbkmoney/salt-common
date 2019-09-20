locale:
  eselect.set:
    - target: {{ salt.pillar.get('locale','en_US.utf8') }}
