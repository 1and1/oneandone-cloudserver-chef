require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerHddResize < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server hdd resize (options)'

      option :disk_id,
             short: '-D DISK_ID',
             long: '--disk-id DISK_ID',
             description: 'Disk ID'

      option :disk_size,
             long: '--disk-size DISK_SIZE',
             description: 'Disk size'

      option :server_id,
             short: '-S SERVER_ID',
             long: '--server-id SERVER_ID',
             description: 'Server ID'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        init_client

        server = OneAndOne::Server.new

        begin
          server.get(server_id: config[:server_id])
        rescue StandardError => e
          if e.message.include? 'NOT_FOUND'
            ui.error("Server ID #{config[:server_id]} not found")
          else
            ui.error(e.message)
          end
          exit 1
        end

        server.modify_hdd(server_id: config[:server_id], hdd_id: config[:disk_id], size: config[:disk_size])

        if config[:wait]
          puts ui.color('Resizing, wait for the operation to complete...', :cyan).to_s
          server.wait_for
          puts "HDD #{config[:disk_id]} is #{ui.color('resized', :bold)}"
        else
          puts "HDD #{config[:disk_id]} is #{ui.color('resizing', :bold)}"
        end
      end
    end
  end
end
