#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "newrelic_plugin"

require "network_ping_newrelic_plugin/version"

module NetworkPingNewrelicPlugin

  class Agent < NewRelic::Plugin::Agent::Base

    agent_guid "com.autouncle.network-ping-newrelic-plugin"
    agent_config_options :hosts, :application_name
    agent_version NetworkPingNewrelicPlugin::VERSION
    agent_human_labels('Network') { application_name }

    def setup_metrics
      @current_hostname = `hostname`.strip
      @timeout = 5 #Seconds
    end

    def poll_cycle
      begin
        hosts.each do |hostname|
          unless hostname == @current_hostname
            ping = `ping -c 1 #{hostname}`
            ping_time = ping[/time=(\d+\.\d+) ms/, 1].to_f

            success = ping_time > 0.0

            # # Uncomment for debugging
            # if success
            #   puts "SUCCESS: #{ping}\n"
            # else
            #   puts "FAILURE: #{ping}\n"
            # end

            report_metric "PingTime/#{hostname}", "ms", (success ? ping_time : @timeout * 1000.0)
            report_metric "PingTimeEndToEnd/#{hostname}/#{@current_hostname}", "ms", (success ? ping_time : @timeout * 1000.0)

            report_metric "PingFailures/#{hostname}", "count", (success ? 0 : 1)
            report_metric "PingFailuresEndToEnd/#{hostname}/#{@current_hostname}", "count", (success ? 0 : 1)

            # puts "DEBUG: PingTime/#{hostname}: #{(success ? ping_time : @timeout * 1000.0)}"
            # puts "DEBUG: PingTimeEndToEnd/#{hostname}/#{@current_hostname}: #{(success ? ping_time : @timeout * 1000.0)}"
            # puts "DEBUG: PingFailures/#{hostname}: #{(success ? 0 : 1)}"
            # puts "DEBUG: PingFailuresEndToEnd/#{hostname}/#{@current_hostname}: #{(success ? 0 : 1)}"
            # puts "\n"
          end
        end
      rescue Exception => e
        puts "Error! #{e.class} #{e.message} #{e.backtrace}"
      end
    end

  end

  class AgentRunner

    def run!
      #
      # Register this agent with the component.
      # The ExampleAgent is the name of the module that defines this
      # driver (the module must contain at least three classes - a
      # PollCycle, a Metric and an Agent class, as defined above).
      #
      NewRelic::Plugin::Config.config_file = File.dirname(__FILE__) + '/../config/newrelic_plugin.yml'

      NewRelic::Plugin::Setup.install_agent :network_ping_newrelic_plugin, NetworkPingNewrelicPlugin

      #
      # Launch the agent; this never returns.
      #
      NewRelic::Plugin::Run.setup_and_run
    end

  end

end
