require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneBlockStorageAttach < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone block storage attach (options)'

      option :id,
             short: '-I ID',
             long: '--id ID',
             description: 'Block storage ID'

      option :server_id,
             short: '-SI SERVER-ID',
             long: '--server-id SERVER-ID',
             description: 'ID of the server that the block storage will be attached to'

      def run
        $stdout.sync = true

        init_client

        block_storage = OneAndOne::BlockStorage.new
        response = block_storage.attach_server(block_storage_id: config[:id], server_id: config[:server_id])

        formated_output(response, true)
        puts "Block storage attached to server #{ui.color('updated', :bold)}"
      end
    end
  end
end
