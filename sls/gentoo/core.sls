locale:
  eselect.set:
    - target: {{ salt.pillar.get('locale','en_IE.utf8') }}
