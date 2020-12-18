/etc/containers/policy.json:
  file.managed:
    - source: salt://{{ slspath }}/files/crio-policy.json
    - require:
      - pkg: k8s_deps

/etc/crio/crio.conf.d/99-custom.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/crio.conf
    - require:
      - pkg: k8s_deps

/etc/crictl.yaml:
  file.managed:
    - source: salt://{{ slspath }}/files/crictl.yaml
    - require:
      - pkg: k8s_deps
