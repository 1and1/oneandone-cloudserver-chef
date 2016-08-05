require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerModify < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server modify SERVER_ID [SERVER_ID] (options)'

      option :fixed_size_id,
             short: '-S FIXED_SIZE_ID',
             long: '--fixed-size-id FIXED_SIZE_ID',
             description: 'ID of the fixed instance size'

      option :cpu,
             short: '-P PROCESSORS',
             long: '--cpu PROCESSORS',
             description: 'The number of processors'

      option :cores,
             short: '-C CORES',
             long: '--cores CORES',
             description: 'The number of cores per processor'

      option :ram,
             short: '-r RAM',
             long: '--ram RAM',
             description: 'The amount of RAM in GB'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        init_client

        name_args.each do |server_id|
          server = OneAndOne::Server.new

          begin
            server.get(server_id: server_id)
          rescue StandardError => e
            if e.message.include? 'NOT_FOUND'
              ui.error("Server ID #{server_id} not found. Skipping.")
            else
              ui.error(e.message)
            end
            next
          end

          server.modify_hardware(
            fixed_instance_id: config[:fixed_size_id],
            vcore: config[:cpu],
            cores_per_processor: config[:cores],
            ram: config[:ram]
          )

          if config[:wait]
            puts ui.color('Reconfiguring, wait for the operation to complete...', :cyan).to_s
            server.wait_for

            puts "\t#{ui.color('ID', :cyan)}: #{server.id}"
            puts "\t#{ui.color('Name', :cyan)}: #{server.specs['name']}"
            puts "\t#{ui.color('Fixed Size ID', :cyan)}: #{server.specs['hardware']['fixed_instance_size_id']}"
            puts "\t#{ui.color('Processors', :cyan)}: #{server.specs['hardware']['vcore']}"
            puts "\t#{ui.color('Cores per Processor', :cyan)}: #{server.specs['hardware']['cores_per_processor']}"
            puts "\t#{ui.color('RAM (GB)', :cyan)}: #{server.specs['hardware']['ram']}\n"

            puts "Server's hardware is #{ui.color('modified', :bold)}"
          else
            puts "Server's hardware is #{ui.color('being modified', :bold)}"
          end
        end
      end
    end
  end
end
