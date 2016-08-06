require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneIpList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone ip list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::PublicIP.new.list
        formated_output(response, true)

        ip_list = [
          ui.color('ID', :bold),
          ui.color('IP Address', :bold),
          ui.color('DHCP', :bold),
          ui.color('State', :bold),
          ui.color('Data Center', :bold),
          ui.color('Assigned To', :bold)
        ]
        response.each do |ip|
          ip_list << ip['id']
          ip_list << ip['ip']
          ip_list << ip['is_dhcp'].to_s
          ip_list << ip['state']
          ip_list << ip['datacenter']['country_code']
          ip_list << (ip['assigned_to'].nil? ? '' : ip['assigned_to']['name'])
        end

        puts ui.list(ip_list, :uneven_columns_across, 6)
      end
    end
  end
end
