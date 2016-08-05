require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneFirewallList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone firewall list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::Firewall.new.list
        formated_output(response, true)

        firewall_list = [
          ui.color('ID', :bold),
          ui.color('Name', :bold),
          ui.color('State', :bold)
        ]
        response.each do |fw|
          firewall_list << fw['id']
          firewall_list << fw['name']
          firewall_list << fw['state']
        end

        puts ui.list(firewall_list, :uneven_columns_across, 3)
      end
    end
  end
end
