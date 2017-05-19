Gem::Specification.new do |spec|
  spec.name          = "cli"
  spec.version       = "0.0.0"
  spec.authors       = ["CAOS"]
  spec.email         = [""]

  spec.summary       = %q{Blackjack CLI}
  spec.license       = "MIT"

  spec.add_dependency "app"
  spec.add_dependency "rmagick"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
