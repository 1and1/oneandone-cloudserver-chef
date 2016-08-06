require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerStop < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server stop SERVER_ID [SERVER_ID] (options)'

      option :force,
             long: '--force',
             description: 'Force hardware shutdown.'

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
          response = server.change_status(server_id: server_id, action: 'POWER_OFF', method: method)

          if config[:wait]
            puts ui.color('Stopping, wait for the operation to complete...', :cyan).to_s
            server.wait_for
            puts "Server '#{server.specs['name']}' is #{ui.color('stopped', :bold)}"
          else
            puts "Server '#{response['name']}' is #{ui.color('stopping', :bold)}"
          end
        end
      end
    end
  end
end
