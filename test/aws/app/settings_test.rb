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
      Aws::App::Settings.get_setting_physical_name({
        name: 'testapp-testenvironment-testsetting'
      })
  end

  def test_get_setting_name_with_application_and_environment
    assert_equal 'testapp-testenvironment-testsetting',
      Aws::App::Settings.get_setting_physical_name({
        application: 'testapp',
        environment: 'testenvironment',
        name: 'testsetting'
      })
  end

  def test_get_setting_name_with_only_application
    assert_raise Aws::App::Settings::Error do
      Aws::App::Settings.get_setting_physical_name({
        application: 'testapp',
        name: 'testsetting'
      })
    end
  end

  def test_get_setting_name_with_only_environment
    assert_raise Aws::App::Settings::Error do
      Aws::App::Settings.get_setting_physical_name({
        environment: 'testenvironment',
        name: 'testsetting'
      })
    end
  end

  def test_get_list
    VCR.use_cassette(__method__, :match_requests_on => [:method]) do
      assert_equal(
        [{
          name: 'testapp-testenvironment-testsetting',
          physical_name: 'testapp-testenvironment-testsetting',
          value: 'Sierra is an artist.'
        }],
        without_expires_at(
          Aws::App::Settings.get_list([
            {
              name: 'testapp-testenvironment-testsetting'
            }
          ])
        )
      )
    end
  end

  def test_get_list_by_physical_name
    VCR.use_cassette(__method__, :match_requests_on => [:method]) do
      assert_equal(
        [{
          physical_name: 'testapp-testenvironment-testsetting',
          value: 'Sierra is an artist.'
        }],
        without_expires_at(
          Aws::App::Settings.get_list([
            {
              physical_name: 'testapp-testenvironment-testsetting'
            }
          ])
        )
      )
    end
  end

  def test_get_list_with_no_name
    VCR.use_cassette(__method__, :match_requests_on => [:method]) do
      assert_raise Aws::App::Settings::Error do
        Aws::App::Settings.get_list([
          {
            useless: 'testapp-testenvironment-testsetting'
          }
        ])
      end
    end
  end

  def test_get_list_by_application_and_environment
    VCR.use_cassette(__method__, :match_requests_on => [:method]) do
      assert_equal(
        [{
          physical_name: 'testapp-testenvironment-testsetting',
          value: 'Sierra is an artist.',
          application: 'testapp',
          environment: 'testenvironment',
          name: 'testsetting'
        }],
        without_expires_at(
          Aws::App::Settings.get_list([
            {
              application: 'testapp',
              environment: 'testenvironment',
              name: 'testsetting'
            }
          ])
        )
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

  def test_cache_setting
    Aws::App::Settings.purge_cache
    Timecop.freeze(Time.now) # Time doesn't change during this test.
    Aws::App::Settings::SystemsManagerStore.any_instance.expects(:get_settings).once.
      returns(mock_response)
    VCR.use_cassette(__method__, :match_requests_on => [:method]) do
      requested_settings = [{
        physical_name: 'testapp-testenvironment-testsetting'
      }]
      expected_response = [{
        physical_name: 'testapp-testenvironment-testsetting',
        value: 'Sierra is an artist.'
      }]
      # The first time should send a request to AWS for the value of the setting.
      # The second request should be cached.
      2.times do
        assert_equal(expected_response,
          without_expires_at(Aws::App::Settings.get_list(requested_settings)))
      end
    end
    Timecop.return
  end

  def test_cache_expires
    Aws::App::Settings.purge_cache
    Aws::App::Settings::SystemsManagerStore.any_instance.expects(:get_settings).twice.
      returns(mock_response)
    VCR.use_cassette(__method__, :match_requests_on => [:method]) do
      requested_settings = [{
        physical_name: 'testapp-testenvironment-testsetting'
      }]
      expected_response = [{
        physical_name: 'testapp-testenvironment-testsetting',
        value: 'Sierra is an artist.'
      }]
      # The first time should send a request to AWS for the value of the setting.
      # The second request should be cached.
      2.times do
        assert_equal(expected_response,
          without_expires_at(Aws::App::Settings.get_list(requested_settings)))
        Timecop.travel(Time.now + 30 * 60)
      end
    end
    Timecop.return
  end

  private

  def without_expires_at(responses)
    responses.map do |response|
      (clone = response.clone).delete(:expires_at)
      clone
    end
  end

  def mock_response
    # This is a fake list of settings, ready for someone to call .name and .value
    [
      Object.new.tap do |mock|
        mock.expects(:name).at_least_once.
          returns('testapp-testenvironment-testsetting')
        mock.expects(:value).at_least_once.
          returns('Sierra is an artist.')
      end
    ]
  end

end
