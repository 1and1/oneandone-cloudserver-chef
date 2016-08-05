require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::Server.new.list
        formated_output(response, true)

        server_list = [
          ui.color('ID', :bold),
          ui.color('Name', :bold),
          ui.color('State', :bold),
          ui.color('Data Center', :bold)
        ]
        response.each do |server|
          server_list << server['id']
          server_list << server['name']
          server_list << server['status']['state']
          server_list << server['datacenter']['country_code']
        end

        puts ui.list(server_list, :uneven_columns_across, 4)
      end
    end
  end
end
