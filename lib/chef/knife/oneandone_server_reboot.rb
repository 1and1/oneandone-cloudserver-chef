require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerReboot < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server reboot SERVER_ID [SERVER_ID] (options)'

      option :force,
             long: '--force',
             description: 'Force hardware restart.'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        init_client

        method = config[:force] ? 'HARDWARE' : 'SOFTWARE'

        name_args.each do |server_id|
          server = OneAndOne::Server.new
          response = server.change_status(server_id: server_id, action: 'REBOOT', method: method)

          if config[:wait]
            puts ui.color('Rebooting, wait for the operation to complete...', :cyan).to_s
            server.wait_for
            puts "Server '#{server.specs['name']}' is #{ui.color('rebooted', :bold)}"
          else
            puts "Server '#{response['name']}' is #{ui.color('rebooting', :bold)}"
          end
        end
      end
    end
  end
end
