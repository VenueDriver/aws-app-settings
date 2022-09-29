# aws-app-settings

A Ruby gem for cloud applications to use for managing configuration settings and secrets with AWS Systems Manager.

This gem provides a caching mechanism with a configurable time-to-live, enabling you to rotate your application secrets or change your configuration settings without re-deploying your app.

It will create and retrieve settings using a pattern that includes the application and environment names, for enabling the separation of environments.

## Features

### Caching

The settings are cached in memory for 15 minutes, to reduce the number of AWS API calls.  The caching behavior is currently not configurable.

TODO: Make the caching more configurable.

### Environment variable overrides

_coming soon_

TODO: Each setting has a name, and if you set an environment variable with that name then it will override the setting from Systems Manager.

### Load environment variables from `.env` files

_coming soon_

TODO: You can configure those enviornment variables in a `.env` file during development.

### Separate setting names for separate environments

_coming soon_

TODO: You can interpolate the environment or application name into the setting name, so that you can provide a separate value for different environments.

### Coalescing

The AWS API calls are coalesced into one when possible, so that it will only require one API call to fetch all required settings.  Those values are also cached, farther reducing the number of API calls to AWS Systems Manager.

### Support for AWS Amplify secrets

AWS Amplify has a command-line mechanism for [configuring secrets](https://docs.amplify.aws/cli/function/secrets/#configuring-secret-values) for a Lambda function within an Amplify app.  You can use `amplify update function` to configure secrets.

But you're responsible for writing the code to retrieve those secrets from the parameter store in AWS Systems Manager.

Amplify doesn't offer any help with setting it up so that you only load those secrets during the initialization of your Lambda environment and not during each function invocation.

Amplify also doesn't offer any help with setting it up to expire the cache and reload when necessary during function invocations.

Amplify also doesn't offer any help with overriding the settings with environment variables or `.env` files during development and testing.

This gem handles things like that.

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
      name: 'testapp-testenvironment-testsetting',
      physical_name: 'testapp-testenvironment-testsetting',
      value: 'TEST VALUE!'
    }

To get a setting from the cloud using a naming convention that includes the application name and the environment name, enabling separation of environments:

    Aws::App::Settings.get_list([
      {
        application: 'testapp',
        environment: 'testenvironment',
        name: 'testsetting'
      }
    ])

Returns:

    {
      application: 'testapp',
      environment: 'testenvironment',
      name: 'testsetting'
      physical_name: 'testapp-testenvironment-testsetting',
      value: 'TEST VALUE!'
    }

This gets the same secret as the first example, but it encapsulates the logic for computing the physical name of the setting.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test-unit` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/VenueDriver/aws-app-settings.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
