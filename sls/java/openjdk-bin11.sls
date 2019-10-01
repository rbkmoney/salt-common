include:
  - java.common

openjdk-bin11:
  pkg.installed:
    - pkgs:
      - dev-java/openjdk-bin: "~:11[headless-awt,gentoo-vm,-cups,-webstart,-alsa]"
