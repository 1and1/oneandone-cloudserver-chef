require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerHddAdd < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server hdd add HDD_SIZE [HDD_SIZE] (options)'

      option :id,
             short: '-I ID',
             long: '--server-id ID',
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
          server.get(server_id: config[:id])
        rescue StandardError => e
          if e.message.include? 'NOT_FOUND'
            ui.error("Server ID #{config[:id]} not found")
          else
            ui.error(e.message)
          end
          exit 1
        end

        hdds = []

        name_args.each do |size|
          hdds << { 'size' => size, 'is_main' => false }
        end

        if hdds.empty?
          ui.error('At least one value for HDD size must be specified.')
        else
          server.add_hdds(hdds: hdds)

          if config[:wait]
            puts ui.color('Adding, wait for the operation to complete...', :cyan).to_s
            server.wait_for
            puts "New HDD(s) is/are #{ui.color('added', :bold)}"
          else
            puts "New HDD(s) is/are #{ui.color('being added', :bold)}"
          end
        end
      end
    end
  end
end
