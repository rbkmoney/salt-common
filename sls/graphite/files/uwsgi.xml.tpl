<?xml version="1.0" encoding="utf-8"?>
<uwsgi>
  <plugins>python27</plugins>
  <master/>
  <single-interpreter/>
  <!-- TODO: take number of processes from some variable -->
  <processes>${processes}</processes>
  <socket>${socket}</socket>
  % if # startswith?
  <chown-socket>nginx:nginx</chown-socket>
  <chmod-socket>640</chmod-socket>
  % endif
  <user>carbon</user>
  <uid>carbon</uid>
  <chdir>/etc/%n</chdir>
  <harakiri>120</harakiri>
  <post-buffering>8192</post-buffering>
  <post-buffering-bufsize>65536</post-buffering-bufsize>
  <env>DJANGO_SETTINGS_MODULE=graphite.settings</env>
  <module>wsgi</module>
</uwsgi>
