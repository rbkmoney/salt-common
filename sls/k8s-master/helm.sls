{% if "k8s-master" in grains.get('role', []) %}
cilium_repository_is_managed:
  helm.repo_managed:
    - present:
      - name: cilium
        url: https://helm.cilium.io

/tmp/cilium.yaml:
  file.managed:
    - source: salt://{{ slspath }}/files/cilium-config.yml
    - template: jinja

cilium_deploy:
  helm.release_present:
    - name: cilium
    - chart: cilium/cilium
    - namespace: kube-system
    - version: {{ pillar['kubernetes']['cilium']['version'] }}
    - values: /tmp/cilium.yaml
    - kvflags:
        kubeconfig: /etc/kubernetes/admin.conf
    - require:
      - helm: cilium_repository_is_managed
      - file: "/tmp/cilium.yaml"
{% endif %}
