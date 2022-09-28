# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'aws/app/settings'

require 'test-unit'
require 'mocha/test_unit'
require 'timecop'
require 'climate_control'

require 'vcr'
require 'pry'
require 'byebug'
require 'awesome_print'

VCR.configure do |config|
  config.cassette_library_dir = File.join(__dir__,'vcr_cassettes')
  config.hook_into :webmock
end