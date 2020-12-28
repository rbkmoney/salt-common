{% if "k8s-master" in grains.get('role', []) %}
"helm repo add cilium https://helm.cilium.io":
  cmd.run:
    - require:
      - cmd: kubeadm_init

cilium_deploy:
  cmd.run:
    - require:
      - cmd: "helm repo add cilium https://helm.cilium.io"
    - name: |
            helm --kubeconfig /etc/kubernetes/admin.conf install \
            cilium cilium/cilium --version {{ pillar['kubernetes']['cilium']['version'] }} \
            --namespace kube-system
            --set kubeProxyReplacement=strict \
            --set k8sServiceHost={{ grains['fqdn_ip6']|join|string }} \
            --set k8sServicePort=6443 \
            --set operator.enabled=false \
            --set ipam.mode=kubernetes \
            --set tunnel=vxlan

{% endif %}
