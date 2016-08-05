require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerStart < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server start SERVER_ID [SERVER_ID] (options)'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        init_client

        name_args.each do |server_id|
          server = OneAndOne::Server.new
          response = server.change_status(server_id: server_id, action: 'POWER_ON')

          if config[:wait]
            puts ui.color('Starting, wait for the operation to complete...', :cyan).to_s
            server.wait_for
            puts "Server '#{server.specs['name']}' is #{ui.color('started', :bold)}"
          else
            puts "Server '#{response['name']}' is #{ui.color('starting', :bold)}"
          end
        end
      end
    end
  end
end
