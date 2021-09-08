{% from tpldir+"/map.jinja" import confmap with context %}
{% set k8sname = grains['k8sname'] %}

{% if grains['os_family'] == "Debian" %}
kube.repo:
  pkgrepo.managed:
    - name: deb http://apt.kubernetes.io/ kubernetes-xenial main
    - dist: kubernetes-xenial
    - file: /etc/apt/sources.list.d/kube.list
    - gpgcheck: 1
    - key_url: https://packages.cloud.google.com/apt/doc/apt-key.gpg

helm.repo:
  pkgrepo.managed:
    - name: deb https://baltocdn.com/helm/stable/debian/ all main
    - dist: all
    - file: /etc/apt/sources.list.d/helm.list
    - gpgcheck: 1
    - key_url: https://helm.baltorepo.com/organization/signing.asc

docker_repo:
  pkgrepo.managed:
    - humanname: Docker
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ grains['oscodename'] }} stable
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/docker.list
    - gpgcheck: 1
    - key_url: https://download.docker.com/linux/ubuntu/gpg
{% endif %}

include:
  - {{ slspath }}/kmod
  - {{ slspath }}/sysctl
  - {{ slspath }}/crio
  - {{ slspath }}/kubelet
  - {{ slspath }}/helm
  - {{ slspath }}/kube-join-token

k8s_deps:
  pkg.installed:
    - pkgs: {{ confmap.KubePkgs }}

{{ confmap.criService }}:
  service.running:
    - enable: True
    - watch:
      - file: /etc/containers/policy.json
      - file: /etc/crio/crio.conf.d/99-custom.conf
      - file: /etc/crictl.yaml
    - require:
      - pkg: k8s_deps

/etc/kubernetes/manifests/.keep_sys-cluster_kubernetes-0:
  file.absent

{% if "k8s-master" in grains.get('role', []) %}
/tmp/config.yaml:
  file.managed:
    - source: salt://{{ slspath }}/files/kubeadm-config.yml
    - template: jinja

kubeadm_init:
  cmd.run:
    - name: kubeadm init --skip-phases=addon/kube-proxy --upload-certs {% if confmap.criService == 'crio' %}--cri-socket /var/run/crio/crio.sock {% endif %}--config /tmp/config.yaml
    - creates: /etc/kubernetes/kubelet.conf
    - require:
      - service: {{ confmap.criService }}
      - file: /tmp/config.yaml
      - file: /etc/kubernetes/manifests/.keep_sys-cluster_kubernetes-0
    - require_in:
      - helm:  cilium_repository_is_managed
      - module: kube_join_command
      - module: kube_join_key
{% endif %}

{% if "k8s-plane" in grains.get('role', []) %}
{% for mastername, com in salt['mine.get']('*', 'kube_join_command_'+k8sname) | dictsort() %}
{% set command = com %}
  {% for i, key in salt['mine.get']('*', 'kube_join_key_'+k8sname) | dictsort() %}
{{ command }} --control-plane --certificate-key {{ key }} {% if confmap.criService == 'crio' %}--cri-socket /var/run/crio/crio.sock{% endif %}:
    cmd.run:
      - creates: /etc/kubernetes/kubelet.conf
      - require:
        - file: /etc/kubernetes/manifests/.keep_sys-cluster_kubernetes-0
  {% endfor %}
{% endfor %}
{% endif %}

{% if "k8s-worker" in grains.get('role', []) %}
/etc/kubernetes/manifests/.keep_sys-cluster_kubelet-0:
  file.absent
{% for mastername, com in salt['mine.get']('*', 'kube_join_command_'+k8sname) | dictsort() %}
{% set command = com %}
{{ command }} {% if confmap.criService == 'crio' %}--cri-socket /var/run/crio/crio.sock{% endif %}:
    cmd.run:
      - creates: /etc/kubernetes/kubelet.conf
      - require:
        - file: /etc/kubernetes/manifests/.keep_sys-cluster_kubernetes-0
        - file: /etc/kubernetes/manifests/.keep_sys-cluster_kubelet-0
{% endfor %}
{% endif %}
