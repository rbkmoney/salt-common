import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'graphite.settings')
from graphite.wsgi import application
