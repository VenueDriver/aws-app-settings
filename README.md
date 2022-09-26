# aws-app-settings

A Ruby gem for cloud applications to use for managing configuration settings and secrets with AWS Secrets Manager and AWS Systems Manager.

This gem provides a caching mechanism with a configurable time-to-live, enabling you to rotate your application secrets or change your configuration settings without re-deploying your app.

It will create and retrieve settings using a pattern that includes the application and environment names, for enabling the separation of environments.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add aws-app-settings

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install aws-app-settings

## Usage

To get a setting from the cloud, explicitly specifying the name:

    Aws::App::Settings.get_list([
      {
        name: 'testapp-testenvironment-testsetting'
      }
    ])

Returns:

    {
      'testapp-testenvironment-testsetting' => 'test value'
    }

To get a setting from the cloud using a naming convention that includes the application name and the environment name, enabling separation of environments:

    Aws::App::Settings.get_list([
      {
        application: 'testapp',
        environment: 'testenvironment',
        name: 'testsetting'
      }
    ])

This gets the same secret as the first example, but it encapsulates the logic for computing the name of the setting.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test-unit` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/aws-app-settings.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
