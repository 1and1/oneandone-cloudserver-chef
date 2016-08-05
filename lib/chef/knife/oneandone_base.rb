require 'chef/knife'

class Chef
  class Knife
    module OneandoneBase
      def self.included(includer)
        includer.class_eval do
          deps do
            require 'oneandone'
          end

          option :oneandone_api_key,
                 short: '-A API_KEY',
                 long: '--oneandone-api-key API_KEY',
                 description: 'Your 1&1 API access key',
                 proc: proc { |api_token| Chef::Config[:knife][:oneandone_api_key] = api_token }
        end
      end

      def init_client
        OneAndOne.start(Chef::Config[:knife][:oneandone_api_key])
      end

      def formated_output(data, is_exit)
        if config[:format] != default_config[:format]
          ui.output(data)
          exit 0 if is_exit
        end
      end
    end
  end
end
