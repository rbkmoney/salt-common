{% if "k8s-master" in grains.get('role', []) %}
"helm repo add cilium https://helm.cilium.io":
  cmd.run:
    - require:
      - cmd: kubeadm_init

/tmp/cilium.yaml:
  file.managed:
    - source: salt://{{ slspath }}/files/cilium-config.yml
    - template: jinja

cilium_deploy:
  cmd.run:
    - require:
      - cmd: "helm repo add cilium https://helm.cilium.io"
      - file: "/tmp/cilium.yaml"
    - name: |
            helm --kubeconfig /etc/kubernetes/admin.conf install \
            cilium cilium/cilium --version {{ pillar['kubernetes']['cilium']['version'] }} \
            --namespace kube-system -f /tmp/cilium.yaml
{% endif %}
