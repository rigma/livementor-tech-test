
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "livementor_tech_test/version"

Gem::Specification.new do |spec|
  spec.name          = "livementor-tech-test"
  spec.version       = LiveMentorTechTest::VERSION
  spec.authors       = ["rigma"]
  spec.email         = ["rigbuntu@gmail.com"]

  spec.summary = "A technical test made for an interview round with LiveMentor"
  spec.description = "This is a technical test that I've made for an interview round with LiveMentor. It converts JSON files into CSV files."
  spec.homepage      = "https://github.com/rigma/livementor-tech-test"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
