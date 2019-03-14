# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'safe_pretty_json/version'

Gem::Specification.new do |spec|
  spec.name          = 'safe_pretty_json'
  spec.version       = SafePrettyJson::VERSION
  spec.authors       = ['contribu']
  spec.email         = ['contribu@example.com']

  spec.summary       = 'String to String Pretty Json preserving floating value and key order'
  spec.description   = 'This gem provide direct pretty json conversion from string to string.'
  spec.homepage      = 'https://github.com/contribu/safe_pretty_json'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|.circleci)/|safe_pretty_json-.*\.gem}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.extensions = ['ext/safe_pretty_json/extconf.rb']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rake-compiler', '~> 1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.65'
end
