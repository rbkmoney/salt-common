{% set terminus_use_flags = salt['pillar.get']('terminus_use_flags',
                                               '-pcf,psf,center-tilde,-ru-g,-a-like-o,distinct-l,ru-dv,ru-i') %}

terminus:
  pkg.installed:
    - pkgs:
      - media-fonts/terminus-font: '[{{ terminus_use_flags }}]'
