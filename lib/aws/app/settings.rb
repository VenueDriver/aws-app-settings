# frozen_string_literal: true

require_relative 'settings/version'
require_relative 'settings/systems-manager-store'

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
            (setting[:name] or setting[:physical_name]) }

        settings = settings.map do |setting|
          setting.tap do |setting|
            setting[:physical_name] = get_setting_physical_name(setting)
          end
        end

        SystemsManagerStore.new.get_settings(
          names: settings.map{|setting| setting[:physical_name] },
            with_decryption: true,
          )['parameters'].map do |parameter|
              settings.find{ |setting|
                setting[:physical_name].eql? parameter.name }.merge(
                  physical_name: parameter.name,
                  value: parameter.value
                )
            end.tap do |secrets|
              if secrets.empty?
                raise Error.new 'Could not get settings from AWS SSM.  ' +
                  'Are you authenticated to the correct account?'
              end
          end
      end

      def self.get_setting_physical_name(setting)
        if setting[:application] and setting[:environment]
          [
            setting[:application],
            setting[:environment],
            setting[:name]
          ].join('-')
        elsif setting[:application] or setting[:environment]
          raise Error.new 'The application and the environment for ' +
            'an application setting must both be specified together.'
        elsif setting[:physical_name]
          setting[:physical_name]
        elsif setting[:name]
          setting[:name]
        else
          raise Error.new 'Please specify a name for the setting.'
        end
      end

    end
  end
end
