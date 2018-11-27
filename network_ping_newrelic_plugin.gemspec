# -*- encoding: utf-8 -*-
$: << File.expand_path("../lib", __FILE__)
require "network_ping_newrelic_plugin/version"

Gem::Specification.new do |s|
  s.name        = 'network_ping_newrelic_plugin'
  s.version     = NetworkPingNewrelicPlugin::VERSION
  s.date        = '2015-07-21'
  s.summary     = "Gem to effectively report network ping metrics to New Relic"
  s.description = "Read summary"
  s.authors     = ["Niels Kristian"]
  s.email       = 'nk.schjoedt@gmail.com'
  s.files       = `git ls-files`.split($/)
  s.require_paths = ["lib"]
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }

  s.add_dependency 'newrelic_plugin'
  s.add_dependency 'dante'
  s.add_dependency 'json', '1.8.6'

  s.add_development_dependency "bundler", "~> 1.17"
end
