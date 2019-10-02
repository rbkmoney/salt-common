{% import 'pkg/common' as pkg %}
sys-apps/baselayout-java:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('sys-apps/baselayout-java') }}

dev-java/java-config:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-java/java-config') }}

app-eselect/eselect-java:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-eselect/eselect-java') }}

{% if grains.get('hwclass', '') == 'container' and grains.get('container_type', 'docker') == 'docker' %}
/usr/libexec/eselect-java/run-java-tool.bash:
  file.patch:
    - source: salt://java/files/run-java-tool-xattr.patch
    - hash: sha256=a7ff220ffa8e9a2276555ce35b495973e1cdcc1debe6cfd836e92c04527f2ad6
    - require:
      - pkg: app-eselect/eselect-java
{% endif %}
