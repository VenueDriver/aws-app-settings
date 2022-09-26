# frozen_string_literal: true

require "test_helper"

class Aws::App::SettingsTest < Test::Unit::TestCase
  def version
    assert do
      ::Aws::App::Settings.const_defined?(:VERSION)
    end
  end

  def test_get_setting_name
    assert_equal 'testapp-testenvironment-testsetting',
      Aws::App::Settings.get_setting_name({
        name: 'testapp-testenvironment-testsetting'
      })
  end

  def test_get_setting_name_with_application_and_environment
    assert_equal 'testapp-testenvironment-testsetting',
      Aws::App::Settings.get_setting_name({
        application: 'testapp',
        environment: 'testenvironment',
        name: 'testsetting'
      })
  end

  def test_get_setting_name_with_only_application
    assert_raise Aws::App::Settings::Error do
      Aws::App::Settings.get_setting_name({
        application: 'testapp',
        name: 'testsetting'
      })
    end
  end

  def test_get_setting_name_with_only_environment
    assert_raise Aws::App::Settings::Error do
      Aws::App::Settings.get_setting_name({
        environment: 'testenvironment',
        name: 'testsetting'
      })
    end
  end

  def test_get_list
    VCR.use_cassette(__method__, :match_requests_on => [:method]) do
      assert_equal(
        {
        'testapp-testenvironment-testsetting' => 'Sierra is an artist.'
        },
        Aws::App::Settings.get_list([
          {
            name: 'testapp-testenvironment-testsetting'
          }
        ])
      )
    end
  end

  def test_get_list_by_application_and_environment
    VCR.use_cassette(__method__, :match_requests_on => [:method]) do
      assert_equal(
        {
        'testapp-testenvironment-testsetting' => 'Sierra is an artist.'
        },
        Aws::App::Settings.get_list([
          {
            application: 'testapp',
            environment: 'testenvironment',
            name: 'testsetting'
          }
        ])
      )
    end
  end

  def test_get_list_needs_a_list
    assert_raise Aws::App::Settings::Error do
      expect Aws::App::Settings.get_list(name: 'test-setting')
    end
  end

  def test_get_list_needs_a_name_for_each_setting
    assert_raise Aws::App::Settings::Error do
      expect Aws::App::Settings.get_list([
        {name: 'test-setting'},
        {no_name:true}
      ])
    end
  end
end
