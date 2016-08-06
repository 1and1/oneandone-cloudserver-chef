require 'chef/knife/oneandone_base'
require '1and1/helpers'

class Chef
  class Knife
    class OneandoneFirewallCreate < Knife
      include Knife::OneandoneBase
      include Oneandone::Helpers

      banner 'knife oneandone firewall create (options)'

      option :name,
             short: '-n NAME',
             long: '--name NAME',
             description: 'Name of the firewall (required)'

      option :description,
             long: '--description DESCRIPTION',
             description: 'Description of the firewall'

      option :port_from,
             long: '--port-from [PORT_FROM]',
             description: 'A comma separated list of the first firewall ports in range (80,161,443)'

      option :port_to,
             long: '--port-to [PORT_TO]',
             description: 'A comma separated list of the second firewall ports in range (80,162,443)'

      option :protocol,
             short: '-p [PROTOCOL]',
             long: '--protocol [PROTOCOL]',
             description: 'A comma separated list of the firewall protocols (TCP,UDP,TCP/UDP,ICMP,IPSEC,GRE)'

      option :source,
             short: '-S [SOURCE_IP]',
             long: '--source [SOURCE_IP]',
             description: 'A comma separated list of the source IPs allowed to access though the firewall'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        validate(config[:name], '-n NAME')
        validate(config[:protocol], 'at least one value for --protocol [PROTOCOL]')

        protocols = split_delimited_input(config[:protocol])
        ports_from = split_delimited_input(config[:port_from])
        ports_to = split_delimited_input(config[:port_to])
        sources = split_delimited_input(config[:source])

        validate_rules(ports_from, ports_to, protocols)

        rules = []

        for i in 0..(protocols.length - 1)
          rule = {
            'protocol' => protocols[i].upcase,
            'port_from' => ports_from[i].nil? ? nil : ports_from[i].to_i,
            'port_to' => ports_to[i].nil? ? nil : ports_to[i].to_i,
            'source' => sources[i]
          }
          rules << rule
        end

        init_client

        firewall = OneAndOne::Firewall.new
        response = firewall.create(name: config[:name], description: config[:description], rules: rules)

        if config[:wait]
          firewall.wait_for
          formated_output(firewall.get, true)
          puts "Firewall policy #{response['id']} is #{ui.color('created', :bold)}"
        else
          formated_output(response, true)
          puts "Firewall policy #{response['id']} is #{ui.color('being created', :bold)}"
        end
      end

      def validate_rules(ports_from, ports_to, protocols)
        if ports_from.length != ports_to.length
          ui.error('You must supply equal number of --port-from and --port-to values!')
          exit 1
        end

        if protocols.length < ports_from.length
          ui.error('It is required that the value count of --protocol >= --port-from value count!')
          exit 1
        end
      end
    end
  end
end
