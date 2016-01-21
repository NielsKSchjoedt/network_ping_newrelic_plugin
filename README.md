## New Relic Network Monitoring Plugin

Monitors network connectivity between specified hosts via native ping

### Instructions for running the plugin agent

Plugin can be started as a daemon using the following command:

In foreground

  bundle exec network_ping_newrelic_plugin

In background

  bundle exec network_ping_newrelic_plugin -d -P /path_to_pidfile/network_ping_newrelic_plugin.pid -l /path_to_log/network_ping_newrelic_plugin.log

and stop it with

  bundle exec network_ping_newrelic_plugin -k -P /path_to_pidfile/network_ping_newrelic_plugin.pid

