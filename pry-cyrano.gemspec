# frozen_string_literal: true

require_relative "lib/pry-cyrano/version"

Gem::Specification.new do |gem|
  gem.name = "pry-cyrano"
  gem.version = Pry::Cyrano::VERSION
  gem.authors = ["morissetcl"]
  gem.email = ["morissetcl87@gmail.com"]

  gem.summary = "Autocorrects typos in your Pry console"
  gem.description = "This small Pry plugin captures exceptions that could be due to typos and deduces the correct command based on your database information."
  gem.homepage = "https://github.com/morissetcl/pry-cyrano"
  gem.license = "MIT"
  gem.required_ruby_version = ">= 2.6.0"

  gem.metadata["homepage_uri"] = gem.homepage
  gem.metadata["source_code_uri"] = "https://github.com/morissetcl/pry-cyrano"
  gem.metadata["changelog_uri"] = "https://github.com/morissetcl/pry-cyrano/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gem.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  gem.bindir = "exe"
  gem.executables = gem.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency "rails", "~> 7.0"
  gem.add_runtime_dependency "pry", ">= 0.13", "< 0.15"
end
