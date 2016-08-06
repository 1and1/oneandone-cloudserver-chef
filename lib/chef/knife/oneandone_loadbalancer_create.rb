require 'chef/knife/oneandone_base'
require '1and1/helpers'

class Chef
  class Knife
    class OneandoneLoadbalancerCreate < Knife
      include Knife::OneandoneBase
      include Oneandone::Helpers

      banner 'knife oneandone loadbalancer create (options)'

      option :datacenter_id,
             short: '-D DATACENTER_ID',
             long: '--datacenter-id DATACENTER_ID',
             description: 'ID of the virtual data center',
             proc: proc { |datacenter_id| Chef::Config[:knife][:datacenter_id] = datacenter_id }

      option :name,
             short: '-n NAME',
             long: '--name NAME',
             description: 'Name of the load balancer (required)'

      option :description,
             long: '--description DESCRIPTION',
             description: 'Description of the load balancer'

      option :health_check,
             long: '--health-check HEALTH_CHECK',
             description: 'Health check test: TCP, ICMP or NONE. Default is TCP.',
             default: 'TCP'

      option :health_int,
             long: '--health-int HEALTH_INTERVAL',
             description: 'Health check interval (sec.). Default is 15.',
             default: 15

      option :health_path,
             long: '--health-path HEALTH_PATH',
             description: 'URL to call for the health checking'

      option :health_regex,
             long: '--health-regex HEALTH_REGEX',
             description: 'Regular expression to check for the health checking'

      option :method,
             short: '-m METHOD',
             long: '--method METHOD',
             description: 'Balancing procedure: ROUND_ROBIN or LEAST_CONNECTIONS. Default is ROUND_ROBIN.',
             default: 'ROUND_ROBIN'

      option :persistence,
             short: '-P',
             long: '--persistence',
             description: 'Enable load balancer persistence (true by default)',
             boolean: true,
             default: true

      option :persistence_int,
             long: '--persistence-int PERSISTENCE_INTERVAL',
             description: 'Persistence interval (sec.). Default is 1200.',
             default: 1200

      option :port_balancer,
             long: '--port-balancer [PORT_BALANCER]',
             description: 'A comma separated list of the load balancer ports (80,161,443)'

      option :port_server,
             long: '--port-server [PORT_SERVER]',
             description: 'A comma separated list of the servers ports (8080,161,443)'

      option :protocol,
             short: '-p [PROTOCOL]',
             long: '--protocol [PROTOCOL]',
             description: 'A comma separated list of the load balancer protocols (TCP,UDP)'

      option :source,
             short: '-S [SOURCE_IP]',
             long: '--source [SOURCE_IP]',
             description: 'A comma separated list of the source IPs from which the access is allowed'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        validate(config[:name], '-n NAME')
        validate(config[:protocol], 'at least one value for --protocol [PROTOCOL]')

        protocols = split_delimited_input(config[:protocol])
        ports_balancer = split_delimited_input(config[:port_balancer])
        ports_server = split_delimited_input(config[:port_server])
        sources = split_delimited_input(config[:source])

        validate_rules(protocols, ports_balancer, ports_server)

        rules = []

        for i in 0..(protocols.length - 1)
          rule = {
            'protocol' => protocols[i].upcase,
            'port_balancer' => ports_balancer[i].to_i,
            'port_server' => ports_server[i].to_i,
            'source' => sources[i]
          }
          rules << rule
        end

        init_client

        load_balancer = OneAndOne::LoadBalancer.new
        response = load_balancer.create(
          name: config[:name],
          description: config[:description],
          health_check_test: config[:health_check].to_s.upcase,
          health_check_interval: config[:health_int].to_i,
          persistence: config[:persistence],
          persistence_time: config[:persistence_int].to_i,
          method: config[:method].to_s.upcase,
          rules: rules,
          health_check_path: config[:health_path],
          health_check_parse: config[:health_regex],
          datacenter_id: config[:datacenter_id]
        )

        if config[:wait]
          puts ui.color('Creating, wait for the operation to complete...', :cyan).to_s
          load_balancer.wait_for
          formated_output(load_balancer.get, true)
          puts "Load balancer #{response['id']} is #{ui.color('created', :bold)}"
        else
          formated_output(response, true)
          puts "Load balancer #{response['id']} is #{ui.color('being created', :bold)}"
        end
      end

      def validate_rules(protocols, ports_balancer, ports_server)
        if (ports_balancer.length != ports_server.length) || (ports_balancer.length != protocols.length)
          ui.error('You must supply equal number of --protocol, --port-balancer and --port-server values!')
          exit 1
        end
      end
    end
  end
end
