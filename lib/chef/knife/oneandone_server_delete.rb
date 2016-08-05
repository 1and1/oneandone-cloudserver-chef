require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerDelete < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server delete SERVER_ID [SERVER_ID] (options)'

      option :keep_ips,
             long: '--keep-ips',
             description: 'Keep server IPs after deleting the server.'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        init_client

        name_args.each do |server_id|
          server = OneAndOne::Server.new

          begin
            server.get(server_id: server_id)
          rescue StandardError => e
            if e.message.include? 'NOT_FOUND'
              ui.error("Server ID #{server_id} not found. Skipping.")
            else
              ui.error(e.message)
            end
            next
          end

          server_name = server.specs['name']

          confirm("Do you really want to delete server '#{server_name}'")

          server.delete(keep_ips: config[:keep_ips])

          if config[:wait]
            begin
              puts ui.color('Deleting, wait for the operation to complete...', :cyan).to_s
              server.wait_for
              puts "Server '#{server_name}' is #{ui.color('deleted', :bold)}"
            rescue StandardError => e
              if e.message.include? 'NOT_FOUND'
                puts "Server '#{server_name}' is #{ui.color('deleted', :bold)}"
              else
                ui.error(e.message)
              end
            end
          else
            puts "Server '#{server_name}' is #{ui.color('being deleted', :bold)}"
          end
        end
      end
    end
  end
end
