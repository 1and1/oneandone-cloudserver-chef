require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneLoadbalancerList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone loadbalancer list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::LoadBalancer.new.list
        formated_output(response, true)

        load_balancers = [
          ui.color('ID', :bold),
          ui.color('Name', :bold),
          ui.color('IP Address', :bold),
          ui.color('Method', :bold),
          ui.color('State', :bold),
          ui.color('Data Center', :bold)
        ]
        response.each do |lb|
          load_balancers << lb['id']
          load_balancers << lb['name']
          load_balancers << lb['ip']
          load_balancers << lb['method']
          load_balancers << lb['state']
          load_balancers << lb['datacenter']['country_code']
        end

        puts ui.list(load_balancers, :uneven_columns_across, 6)
      end
    end
  end
end
