require 'chef/knife/oneandone_base'
require '1and1/helpers'

class Chef
  class Knife
    class OneandoneServerCreate < Knife
      include Knife::OneandoneBase
      include Oneandone::Helpers

      banner 'knife oneandone server create (options)'

      option :datacenter_id,
             short: '-D DATACENTER_ID',
             long: '--datacenter-id DATACENTER_ID',
             description: 'ID of the virtual data center',
             proc: proc { |datacenter_id| Chef::Config[:knife][:datacenter_id] = datacenter_id }

      option :name,
             short: '-n NAME',
             long: '--name NAME',
             description: 'Name of the server (required)'

      option :description,
             long: '--description DESCRIPTION',
             description: 'Description of the server'

      option :appliance_id,
             short: '-I APPLIANCE_ID',
             long: '--appliance-id APPLIANCE_ID',
             description: 'ID of the server appliance (required)',
             proc: proc { |appliance_id| Chef::Config[:knife][:appliance_id] = appliance_id }

      option :fixed_size_id,
             short: '-S FIXED_SIZE_ID',
             long: '--fixed-size-id FIXED_SIZE_ID',
             description: 'ID of the fixed instance size',
             proc: proc { |fixed_size_id| Chef::Config[:knife][:fixed_size_id] = fixed_size_id }

      option :cpu,
             short: '-P PROCESSORS',
             long: '--cpu PROCESSORS',
             description: "The number of processors. Required, if '--fixed-size-id' is not specified."

      option :cores,
             short: '-C CORES',
             long: '--cores CORES',
             description: "The number of cores per processor. Required, if '--fixed-size-id' is not specified."

      option :ram,
             short: '-r RAM',
             long: '--ram RAM',
             description: "The amount of RAM in GB. Required, if '--fixed-size-id' is not specified."

      option :hdd_size,
             short: '-H HDD_SIZE',
             long: '--hdd-size HDD_SIZE',
             description: "The HDD size in GB. Required, if '--fixed-size-id' is not specified."

      option :password,
             short: '-p PASSWORD',
             long: '--password PASSWORD',
             description: "The password of the server's root/administrator user"

      option :rsa_key,
             long: '--rsa-key RSA_KEY',
             description: 'Specify a valid public SSH Key to be copied into your 1&1 server during creation.',
             proc: proc { |rsa_key| Chef::Config[:knife][:rsa_key] = rsa_key }

      option :firewall_id,
             long: '--firewall-id FIREWALL_ID',
             description: 'ID of a firewall policy to be used for the server',
             proc: proc { |firewall_id| Chef::Config[:knife][:firewall_id] = firewall_id }

      option :power_on,
             long: '--power-on BOOLEAN_VALUE',
             description: 'Power on the server after creating (true by default).',
             default: true

      option :ip_id,
             long: '--ip-id IP_ID',
             description: 'ID of an IP address to be used for the server'

      option :load_balancer_id,
             long: '--load-balancer-id LOAD_BALANCER_ID',
             description: 'ID of a load balancer to be used for the server',
             proc: proc { |load_balancer_id| Chef::Config[:knife][:load_balancer_id] = load_balancer_id }

      option :monitoring_policy_id,
             long: '--monitoring-policy-id MONITORING_POLICY_ID',
             description: 'ID of a monitoring policy to be used for the server',
             proc: proc { |monitoring_policy_id| Chef::Config[:knife][:monitoring_policy_id] = monitoring_policy_id }

      option :wait,
             long: '--[no-]wait',
             description: 'Wait for the server deployment to complete (true by default).',
             boolean: true,
             default: true

      def run
        $stdout.sync = true

        validate(config[:name], '-n NAME')
        validate(config[:appliance_id], '-I APPLIANCE_ID')

        init_client

        size_id = config[:fixed_size_id]
        hdds = nil

        if size_id.nil? || size_id.empty?
          hdds = [
            {
              'size' => config[:hdd_size],
              'is_main' => true
            }
          ]
        end

        server = OneAndOne::Server.new
        response = server.create(
          name: config[:name],
          description: config[:description],
          datacenter_id: config[:datacenter_id],
          fixed_instance_id: size_id,
          appliance_id: config[:appliance_id],
          vcore: config[:cpu],
          cores_per_processor: config[:cores],
          ram: config[:ram],
          hdds: hdds,
          power_on: config[:power_on],
          password: config[:password],
          rsa_key: config[:rsa_key],
          firewall_id: config[:firewall_id],
          ip_id: config[:ip_id],
          load_balancer_id: config[:load_balancer_id],
          monitoring_policy_id: config[:monitoring_policy_id]
        )

        if config[:wait]
          puts ui.color('Deploying, wait for the operation to complete...', :cyan).to_s

          # wait for provisioning 30m max
          server.wait_for(timeout: 30, interval: 15)

          formated_output(server.get, true)

          first_password = server.first_password.nil? ? config[:password] : server.first_password
          first_ip = !server.specs['ips'].empty? ? server.specs['ips'][0]['ip'] : ''

          puts "\t#{ui.color('ID', :cyan)}: #{server.id}"
          puts "\t#{ui.color('Name', :cyan)}: #{server.specs['name']}"
          puts "\t#{ui.color('First IP', :cyan)}: #{first_ip}"
          puts "\t#{ui.color('First Password', :cyan)}: #{first_password}\n"

          puts ui.color('done', :bold).to_s
        else
          formated_output(response, true)
          puts "Server #{response['id']} is #{ui.color('being deployed', :bold)}"
        end
      end
    end
  end
end
