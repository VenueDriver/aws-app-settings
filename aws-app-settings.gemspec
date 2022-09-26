# frozen_string_literal: true

require_relative "lib/aws/app/settings/version"

Gem::Specification.new do |spec|
  spec.name = "aws-app-settings"
  spec.version = Aws::App::Setting::VERSION
  spec.authors = ["Ryan Alyn Porter"]
  spec.email = ["rap@endymion.com"]

  spec.summary =
    'A Ruby gem for cloud applications to use for managing configuration ' +
    'settings and secrets with AWS Secrets Manager and AWS Systems Manager.'
  spec.description = <<-DESC
This gem provides a caching mechanism with a configurable time-to-live, enabling
you to rotate your application secrets or change your configuration settings
without re-deploying your app.

It will create and retrieve settings using a pattern that includes the
application and environment names, for enabling the separation of environments.
  DESC
  spec.homepage = "https://github.com/VenueDriver/aws-app-settings"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/VenueDriver/aws-app-settings"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'pry', '~> 0.14.1'
  spec.add_dependency 'vcr', '~> 6.1'
  spec.add_dependency 'byebug', '~> 11.1', '>= 11.1.3'
  spec.add_dependency 'awesome_print', '~> 2.0.0.pre2'
  spec.add_dependency 'mocha', '~> 1.15'
  spec.add_dependency 'timecop', '~> 0.9.5'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
