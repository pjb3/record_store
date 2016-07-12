# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "sequel_record_store"
  spec.version       = "0.4.0"
  spec.authors       = ["Paul Barry"]
  spec.email         = ["mail@paulbarry.com"]

  spec.summary       = %q{Easily store records in your database with Sequel}
  spec.homepage      = "http://github.com/pjb3/record_store"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
