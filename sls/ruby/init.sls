include:
  - ruby.ruby21

app-eselect/eselect-ruby:
  pkg.latest

pkg_rubytools:
  pkg.latest:
    - pkgs:
      - dev-ruby/rubygems
      - virtual/rubygems
      - dev-ruby/rake
      - dev-ruby/rdoc
