lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ahrefs_api/version'

Gem::Specification.new do |spec|
  spec.name          = "ahrefs-api-ruby"
  spec.version       = AhrefsApi::VERSION
  spec.authors       = ["sainu"]
  spec.email         = ["katsutoshi.saino@gmail.com"]
  spec.summary       = %q{Ahrefs API client library, written in Ruby}
  spec.description   = %q{Ahrefs API client library, written in Ruby}
  spec.homepage      = "https://github.com/sainuio/ahrefs-api-ruby/"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "faraday_middleware"
  spec.add_runtime_dependency "activemodel"
  spec.add_runtime_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry"
end
