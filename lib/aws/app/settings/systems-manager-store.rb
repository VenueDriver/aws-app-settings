require 'aws-sdk-ssm'

module Aws
  module App
    module Settings
      class SystemsManagerStore
        def initialize(*args)
          @client = Aws::SSM::Client.new *args
        end

        def get_settings(args)
          @client.get_parameters(args)
        end
      end
    end
  end
end
