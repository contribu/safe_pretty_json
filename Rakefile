# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rake/extensiontask'

RSpec::Core::RakeTask.new(:spec)

gemspec = Gem::Specification.load('safe_pretty_json.gemspec')
Rake::ExtensionTask.new do |ext|
  ext.name = 'safe_pretty_json'
  ext.source_pattern = '*.{c,cpp,h}'
  ext.ext_dir = 'ext/safe_pretty_json'
  ext.lib_dir = 'lib/safe_pretty_json'
  ext.gem_spec = gemspec
end

task default: %i[compile spec]
