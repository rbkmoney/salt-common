include:
  - ruby.ruby23

ruby22:
  pkg.purged:
    - name: 'dev-lang/ruby:2.2'

app-eselect/eselect-ruby:
  pkg.latest

set-ruby-targets:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set RUBY_TARGETS '"ruby23"'
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
