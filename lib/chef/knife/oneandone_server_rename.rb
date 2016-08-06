require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerRename < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server rename (options)'

      option :name,
             short: '-n NAME',
             long: '--server-name NAME',
             description: 'Name of the server'

      option :description,
             long: '--server-desc DESCRIPTION',
             description: 'Description of the server'

      option :id,
             short: '-I ID',
             long: '--server-id ID',
             description: 'Server ID'

      def run
        $stdout.sync = true

        init_client

        server = OneAndOne::Server.new
        response = server.modify(server_id: config[:id], name: config[:name], description: config[:description])

        formated_output(response, true)
        puts "Server name and/or description #{ui.color('updated', :bold)}"
      end
    end
  end
end
