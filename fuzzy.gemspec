# frozen_string_literal: true

require_relative "lib/fuzzy_wuzzy/version"

Gem::Specification.new do |spec|
  spec.name = "fuzzy_wuzzy"
  spec.version = FuzzyWuzzy::VERSION
  spec.authors = ["Delon R. Newman"]
  spec.email = ["contact@delonnewman.name"]

  spec.summary = ""
  spec.description = ""
  spec.homepage = "https://github.com/delonnewman/fuzzy-wuzzy"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "#{spec.homepage}.git"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mini-levenshtein", "~> 0.1.0"
end
