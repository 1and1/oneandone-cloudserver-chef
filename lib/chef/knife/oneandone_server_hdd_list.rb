require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerHddList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server hdd list SERVER_ID [SERVER_ID]'

      def run
        $stdout.sync = true

        server_id = ''

        if name_args.empty?
          ui.error('Server ID must be provided.')
          exit 1
        else
          server_id = name_args[0]
        end

        init_client

        server = OneAndOne::Server.new

        response = server.hdds(server_id: server_id)
        formated_output(response, true)

        hdds = [
          ui.color('ID', :bold),
          ui.color('Size (GB)', :bold),
          ui.color('Main', :bold)
        ]
        response.each do |disk|
          hdds << disk['id']
          hdds << disk['size'].to_s
          hdds << disk['is_main'].to_s
        end

        puts ui.list(hdds, :uneven_columns_across, 3)
      end
    end
  end
end
