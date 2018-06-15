require 'chef/knife/oneandone_base'
require '1and1/helpers'

class Chef
  class Knife
    class OneandoneBlockStorageCreate < Knife
      include Knife::OneandoneBase
      include Oneandone::Helpers

      banner 'knife oneandone block storage create (options)'

      option :name,
             short: '-n NAME',
             long: '--name NAME',
             description: 'Name of the block storage (required)'

      option :size,
             short: '-s SIZE',
             long: '--size SIZE',
             description: 'Size of the block storage (required, min:20, max:500, multipleOf:10)'

      option :description,
             long: '--description DESCRIPTION',
             description: 'Description of the block storage'

      option :datacenter_id,
             short: '-D DATACENTER_ID',
             long: '--datacenter-id DATACENTER_ID',
             description: 'ID of the virtual data center where the block storage will be created',
             proc: proc { |datacenter_id| Chef::Config[:knife][:datacenter_id] = datacenter_id }

      option :server_id,
             long: '--server_id SERVER_ID',
             description: 'ID of the server that the block storage will be attached to'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        validate(config[:name], '-n NAME')
        validate(config[:size], '-s SIZE')

        init_client

        block_storage = OneAndOne::BlockStorage.new
        response = block_storage.create(name: config[:name], description: config[:description], size: config[:size],
                                        datacenter_id: config[:datacenter_id], server_id: config[:server_id])

        if config[:wait]
          block_storage.wait_for
          formated_output(block_storage.get, true)
          puts "Block storage #{response['id']} is #{ui.color('created', :bold)}"
        else
          formated_output(response, true)
          puts "Block storage #{response['id']} is #{ui.color('being created', :bold)}"
        end
      end
    end
  end
end
