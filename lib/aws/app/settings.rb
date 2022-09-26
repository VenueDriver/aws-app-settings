# frozen_string_literal: true
require 'aws-sdk-ssm'

require_relative "settings/version"

module Aws
  module App
    module Settings
      class Error < StandardError; end
      
      def initialize(name:, secret:false, rotate:false)
      end

      def set(name:)
      end

      def self.get_list(settings)
        raise Error.new 'This method requires a list of settings.' unless
          settings.class.eql?(Array)
        raise Error.new 'Each setting in the list must be a hash with a name.' unless
          settings.all?{|setting| setting.class.eql?(Hash) and
            setting[:name] }

        settings = settings.map do |setting|
          { name: get_setting_name(setting) }
        end

        Aws::SSM::Client.new.get_parameters(
          names: settings.map{|setting| setting[:name] },
            with_decryption: true,
          )['parameters'].to_h {
            |parameter| [parameter.name, parameter.value] }.tap do |secrets|
              if secrets.empty?
                raise Error.new 'Could not get settings from AWS SSM.  ' +
                  'Are you authenticated to the correct account?'
              end
          end
      end

      def self.get_setting_name(setting)
        if setting[:application] and setting[:environment]
          [
            setting[:application],
            setting[:environment],
            setting[:name]
          ].join('-')
        elsif setting[:application] or setting[:environment]
          raise Error.new 'The application and the environment for ' +
            'an application setting must both be specified together.'
        else
          setting[:name]
        end
      end

    end
  end
end
