lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'atlas_scientific/version'

Gem::Specification.new do |spec|
  spec.name          = 'atlas_scientific'
  spec.version       = AtlasScientific::VERSION
  spec.authors       = ['Yves Siegrist']
  spec.email         = ['yves@siegrist.io']

  spec.summary       = 'Ruby library to provide an easy abstraction of the I2C command protocol which atlas scientific devices implement'
  spec.homepage      = 'https://github.com/siegy22/atlas_scientific'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'activesupport', '~> 6.0.0'
end
