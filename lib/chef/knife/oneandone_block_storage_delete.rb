require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneBlockStorageDelete < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone block storage delete BLOCK_STORAGE_ID [BLOCK_STORAGE_ID] (options)'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        init_client

        name_args.each do |block_storage_id|
          block_storage = OneAndOne::BlockStorage.new

          begin
            block_storage.get(block_storage_id: block_storage_id)
          rescue StandardError => e
            if e.message.include? 'NOT_FOUND'
              ui.error("Block storage ID #{block_storage_id} not found. Skipping.")
            else
              ui.error(e.message)
            end
            next
          end

          block_storage_name = block_storage.specs['name']

          confirm("Do you really want to delete block storage '#{block_storage_name}'")

          block_storage.delete

          if config[:wait]
            begin
              puts ui.color('Deleting, wait for the operation to complete...', :cyan).to_s
              block_storage.wait_for
              puts "Block storage '#{block_storage_name}' is #{ui.color('deleted', :bold)}"
            rescue StandardError => e
              if e.message.include? 'NOT_FOUND'
                puts "Block storage '#{block_storage_name}' is #{ui.color('deleted', :bold)}"
              else
                ui.error(e.message)
              end
            end
          else
            puts "Block storage '#{block_storage_name}' is #{ui.color('being deleted', :bold)}"
          end
        end
      end
    end
  end
end
