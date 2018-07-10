require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneBlockStorageList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone block storage list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::BlockStorage.new.list
        formated_output(response, true)

        block_storages = [
          ui.color('ID', :bold),
          ui.color('Name', :bold),
          ui.color('Size', :bold),
          ui.color('State', :bold),
          ui.color('Datacenter', :bold),
          ui.color('Server ID', :bold),
          ui.color('Server Name', :bold)
        ]

        response.each do |blks|
          block_storages << blks['id']
          block_storages << blks['name']
          block_storages << blks['size'].to_s
          block_storages << blks['state']
          block_storages << blks['datacenter']['country_code']
          block_storages << (blks['server'].nil? ? '' : blks['server']['id'])
          block_storages << (blks['server'].nil? ? '' : blks['server']['name'])
        end

        puts ui.list(block_storages, :uneven_columns_across, 7)
      end
    end
  end
end
