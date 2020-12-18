systemd-reload:
  cmd.run:
   - name: systemctl --system daemon-reload
   - onchanges:  
     - file: /etc/systemd/system/kubelet.service

/etc/systemd/system/kubelet.service:
  file.managed:
    - source: salt://{{ slspath }}/files/kubelet.service
    - template: jinja
    - require:
      - pkg: k8s_deps

kubelet:
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/system/kubelet.service
    - require:
      - pkg: k8s_deps
      - cmd: systemd-reload
