include:
  - ruby.ruby21

app-eselect/eselect-ruby:
  pkg.latest

set-ruby-targets:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set RUBY_TARGETS '"ruby21"'
    - require:
      - file: augeas-makeconf

pkg_rubytools:
  pkg.latest:
    - pkgs:
      - dev-ruby/rubygems
      - virtual/rubygems
      - dev-ruby/rake
      - dev-ruby/rdoc
    - require:
      - augeas: set-ruby-targets
