require 'aws-sdk-ssm'

module Aws
  module App
    module Settings
      class SystemsManagerStore
        def initialize(*args)
          @client = Aws::SSM::Client.new *args
        end

        def get_settings(*args)
          @client.get_parameters(*args)['parameters']
        end

        def read_setting(args)
          @client.get_parameter(args)
        end

        def create_setting(args)
          @client.put_parameter(args.merge(type:'SecureString'))
        end

        def delete_setting(args)
          @client.delete_parameter(args)
        end
      end
    end
  end
end
