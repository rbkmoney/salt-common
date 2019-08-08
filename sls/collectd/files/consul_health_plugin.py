#!/usr/bin/env python
import collectd
import json
import logging
import time
import urllib
import urllib.error
import urllib.request
from urllib.request import HTTPSHandler
import ssl


PLUGIN = 'consul-health'


def _str_to_bool(value):
    '''
    Python 2.x does not have a casting mechanism for booleans.  The built in
    bool() will return true for any string with a length greater than 0.  It
    does not cast a string with the text "true" or "false" to the
    corresponding bool value.  This method is a casting function.  It is
    insensitive to case and leading/trailing spaces.  An Exception is raised
    if a cast can not be made.
    This was copied from docker-collectd-plugin.py
    '''
    value = str(value).strip().lower()
    if value == 'true':
        return True
    elif value == 'false':
        return False
    else:
        raise ValueError('Unable to cast value (%s) to boolean' % value)


class CollectdLogHandler(logging.Handler):
    '''
    Log handler to forward statements to collectd
    A custom log handler that forwards log messages raised
    at level debug, info, warning, and error
    to collectd's built in logging.  Suppresses extraneous
    info and debug statements using a "verbose" boolean
    Inherits from logging.Handler
    This was copied from docker-collectd-plugin.py
    '''

    def __init__(self, plugin_name='unknown', debug=False, verbose=False):
        '''
        Initializes CollectdLogHandler
        Arguments
            plugin_name -- string name of the plugin (default 'unknown')
            debug   -- boolean to enable debug level logging, defaults to false
            verbose -- boolean to escalate debug level logging up to info
        '''
        self.plugin_name = plugin_name
        self.debug = debug
        self.verbose = verbose

        logging.Handler.__init__(self, level=logging.NOTSET)

    def emit(self, record):
        '''
        Emits a log record to the appropriate collectd log function
        Arguments
        record -- str log record to be emitted
        '''
        if record.msg is not None:
            if record.levelname == 'ERROR':
                collectd.error(self.format(record))
            elif record.levelname == 'WARNING':
                collectd.warning(self.format(record))
            elif record.levelname == 'INFO':
                collectd.info(self.format(record))
            elif record.levelname == 'DEBUG' and self.verbose:
                collectd.info(self.format(record))
            elif record.levelname == 'DEBUG' and self.debug:
                collectd.debug(self.format(record))


class MetricRecord(object):
    '''
    Struct for all information needed to emit a single collectd metric.
    MetricSink is the expected consumer of instances of this class.
    Taken from collectd-nginx-plus plugun.
    '''
    TO_STRING_FORMAT = '[name={},type={},value={},timestamp={}]'

    def __init__(self, metric_name, metric_type, value, timestamp=None):
        self.name = metric_name
        self.type = metric_type
        self.value = value
        self.timestamp = timestamp or time.time()

    def to_string(self):
        return MetricRecord.TO_STRING_FORMAT.format(self.name,
                                                    self.type,
                                                    self.value,
                                                    self.timestamp)


class MetricSink(object):
    '''
    Responsible for transforming and dispatching a MetricRecord via collectd.
    Taken from collectd-nginx-plus plugun.
    '''
    def emit(self, metric_record):
        '''
        Construct a single collectd Values instance from the given MetricRecord
        and dispatch.
        '''
        emit_value = collectd.Values()

        emit_value.time = metric_record.timestamp
        emit_value.plugin = PLUGIN
        emit_value.values = [metric_record.value]
        emit_value.type = metric_record.type
        emit_value.type_instance = metric_record.name

        emit_value.dispatch()


def configure_callback(conf):
    '''
    Configures plugin with config provided from collectd.
    '''
    LOGGER.info('Starting Consul Health Plugin configuration.')
    # Default values of config options
    api_host = 'localhost'
    api_port = 8500
    api_protocol = 'http'
    acl_token = None
    ssl_certs = {'ca_cert': None, 'client_cert': None, 'client_key': None}

    for node in conf.children:
        if node.key == 'ApiHost':
            api_host = node.values[0]
        elif node.key == 'ApiPort':
            api_port = int(node.values[0])
        elif node.key == 'ApiProtocol':
            api_protocol = node.values[0]
        elif node.key == 'AclToken':
            acl_token = node.values[0]
        elif node.key == 'CaCertificate':
            ssl_certs['ca_cert'] = node.values[0]
        elif node.key == 'ClientCertificate':
            ssl_certs['client_cert'] = node.values[0]
        elif node.key == 'ClientKey':
            ssl_certs['client_key'] = node.values[0]
        elif node.key == 'Debug':
            log_handler.debug = _str_to_bool(node.values[0])
        elif node.key == 'Verbose':
            log_handler.verbose = _str_to_bool(node.values[0])

    plugin_conf = {'api_host': api_host,
                   'api_port': api_port,
                   'api_protocol': api_protocol,
                   'acl_token': acl_token,
                   'ssl_certs': ssl_certs,
                   'debug': log_handler.debug,
                   'verbose': log_handler.verbose
                   }

    LOGGER.debug('Plugin Configurations - ')
    for k, v in plugin_conf.items():
        LOGGER.debug('{0} : {1}'.format(k, v))

    consul_plugin = ConsulPlugin(plugin_conf)

    collectd.register_read(
                        consul_plugin.read,
                        name='{0}.{1}:{2}'.format(PLUGIN, api_host, api_port)
                        )


class ConsulPlugin(object):

    def __init__(self, plugin_conf):

        self.consul_agent = ConsulAgent(plugin_conf['api_host'],
                                        plugin_conf['api_port'],
                                        plugin_conf['api_protocol'],
                                        plugin_conf['acl_token'],
                                        plugin_conf['ssl_certs'])
        self.metric_sink = MetricSink()

    def read(self):
        '''
        Collect all metrics and emit to collectd. Will be called once/interval.
        '''
        LOGGER.debug('Starting metrics collection in read callback.')
        self.consul_agent.update_local_config()

        # Return from read callback if config for the agent is not found
        if self.consul_agent.config is None:
            LOGGER.warning('Did not find config of consul at /agent/self.')
            return

        metric_records = []
        metric_records.extend(self._fetch_health_checks())

        # Emit all gathered metrics
        for metric_record in metric_records:
            self.metric_sink.emit(metric_record)

    def _fetch_health_checks(self):
        '''
        Collect the consul-health.service.{service}.{status} type metrics
        possible states - passing, warning, critical
        '''
        LOGGER.debug('Collecting health check metrics.')
        metric_records = []
        checks_map = self.consul_agent.get_health_check_stats()

        if not checks_map:
            return metric_records

        service_checks = checks_map['service']
        node_checks = checks_map['node']

        time_now = time.time()
        for service, stats in service_checks.items():
            for status, count in stats.items():
                metric_name = 'service.{0}.{1}'.format(service, status)
                metric_records.append(MetricRecord(metric_name,
                                                   'gauge',
                                                   count,
                                                   time_now))

        for status, count in node_checks.items():
            metric_name = 'node.{0}'.format(status)
            metric_records.append(MetricRecord(metric_name,
                                               'gauge',
                                               count,
                                               time_now))

        return metric_records


class ConsulAgent(object):
    '''
    Helper class for interacting with consul's http api
    '''
    def __init__(self, api_host, api_port, api_protocol,
                 acl_token, ssl_certs):

        self.api_host = api_host
        self.api_port = api_port
        self.api_protocol = api_protocol
        self.ssl_certs = ssl_certs

        # If acl_token provided, add to header
        self.acl_token = acl_token
        self.headers = {'X-Consul-Token': acl_token} if self.acl_token else {}

        self.base_url = '{0}://{1}:{2}/v1'.format(self.api_protocol,
                                                  self.api_host,
                                                  self.api_port)

        # Endpoint to get config of consul instance
        self.local_config_url = '{0}/agent/self'.format(self.base_url)

        # Health check endpoint
        self.health_checks_url = '{0}/health/node'.format(self.base_url)

        self.config = {}

    def update_local_config(self):
        conf = self.get_local_config()
        if not conf:
            self.config = None
            return
        self.config = conf

    def get_local_config(self):
        return self._send_request(self.local_config_url)

    def get_health_checks(self, node):
        return self._send_request('{0}/{1}'.format(
                                            self.health_checks_url,
                                            node))

    def get_health_check_stats(self):
        '''
        Count service and nodes in states - passing, warning, critical
        '''

        initial = {'passing': 0, 'warning': 0, 'critical': 0}
        stats = {'service': {}, 'node': initial.copy()}
        if not self.config:
            return None
        node = self.config['Config']['NodeName']
        checks = self.get_health_checks(node)
        if not checks:
            return None

        for check in checks:
            status = check['Status']
            # if serviceID field is not empty,
            # means the check is a service check
            if check['ServiceID']:
                service = check['ServiceName']
                stats['service'].setdefault(service, initial.copy())
                stats['service'][service][status] += 1
            # check is a node check
            else:
                stats['node'][status] += 1

        return stats

    def _send_request(self, url):
        '''
        Performs a GET against the given url.
        '''
        LOGGER.debug('Making an api call to {0}'.format(url))
        data = None

        try:
            ctx = ssl.create_default_context()
            ctx.check_hostname = False
            if self.ssl_certs['ca_cert']:
                ctx.load_verify_locations(cafile=self.ssl_certs.ca_cert)
                ctx.load_cert_chain(certfile=self.ssl_certs.client_cert,
                                    keyfile=self.ssl_certs.client_key)
            opener = urllib.request.build_opener(HTTPSHandler(context=ctx))
            opener.addheaders = []
            for k, v in self.headers.items():
                opener.addheaders.append((k, v))
            response = opener.open(url)
            data = response.read()
            data = json.loads(data)
        except urllib.error.HTTPError as e:
            LOGGER.error('HTTPError - status code: {0}, '
                         'received from {1}'.format(e.code, url))
        except urllib.error.URLError as e:
            LOGGER.error('URLError - {0} {1}'.format(url, e.reason))
        except ValueError as e:
            LOGGER.error('Error parsing JSON for url {0}. {1}'.format(url, e))

        return data


# Set up logging
LOG_FILE_DATE_FORMAT = '%Y-%m-%d %H:%M:%S'
LOG_FILE_MESSAGE_FORMAT = '[%(levelname)s] [' + PLUGIN + '] '\
                          '[%(asctime)s UTC]: %(message)s'
formatter = logging.Formatter(fmt=LOG_FILE_MESSAGE_FORMAT,
                              datefmt=LOG_FILE_DATE_FORMAT)
log_handler = CollectdLogHandler('consul-collectd')
log_handler.setFormatter(formatter)
LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.DEBUG)
LOGGER.propagate = False
LOGGER.addHandler(log_handler)

if __name__ == '__main__':
    pass
else:
    collectd.register_config(configure_callback)
