k8s_kmod:
  kmod.present:
    - persist: True
    - mods:
      - br_netfilter
      - overlay
      - xt_TPROXY
      - xt_mark
      - xt_socket

{% if grains['init'] == 'systemd' %}
/etc/modules-load.d/modules.conf:
  file.symlink:
    - target: /etc/modules
    - makedirs: True
    - require:
      - kmod: k8s_kmod
{% endif %}
