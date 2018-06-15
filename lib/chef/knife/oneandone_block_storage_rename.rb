require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneBlockStorageRename < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone block storage rename (options)'

      option :name,
             short: '-n NAME',
             long: '--name NAME',
             description: 'Name of the block storage'

      option :description,
             long: '--description DESCRIPTION',
             description: 'Description of the block storage'

      option :id,
             short: '-I ID',
             long: '--id ID',
             description: 'Block storage ID'

      def run
        $stdout.sync = true

        init_client

        block_storage = OneAndOne::BlockStorage.new
        response = block_storage.modify(block_storage_id: config[:id], name: config[:name],
                                        description: config[:description])

        formated_output(response, true)
        puts "Block storage updated #{ui.color('updated', :bold)}"
      end
    end
  end
end
