{% if "k8s-master" in grains.get('role', []) %}
# New style of module.run. For activation need add
# use_superseded:
#  - module.run
# in /etc/salt/minion file

kube_join_command:
  module.run:
    - mine.send:
      - kube_join_command
      - mine_function: cmd.shell
      - 'kubeadm token create --print-join-command 2>/dev/null'
    - allow_tgt: "G@role:k8s-*"
    - allow_tgt_type: "compound"


kube_join_key:
  module.run:
  - mine.send:
    - kube_join_key
    - 'kubeadm init phase upload-certs --upload-certs  2>&1 | tail -1'
    - mine_function: cmd.shell
  - allow_tgt: "G@role:k8s-*"
  - allow_tgt_type: "compound"
{% endif %}
