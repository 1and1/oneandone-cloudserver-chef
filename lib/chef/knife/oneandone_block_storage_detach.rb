require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneBlockStorageDetach < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone block storage detach (options)'

      option :id,
             short: '-I ID',
             long: '--id ID',
             description: 'Block storage ID'

      def run
        $stdout.sync = true

        init_client

        block_storage = OneAndOne::BlockStorage.new
        response = block_storage.detach_server(block_storage_id: config[:id])

        formated_output(response, true)
        puts "Block storage detached from server #{ui.color('updated', :bold)}"
      end
    end
  end
end
