require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneDatacenterList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone datacenter list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::Datacenter.new.list
        formated_output(response, true)

        datacenters = [
          ui.color('ID', :bold),
          ui.color('Location', :bold),
          ui.color('Country Code', :bold)
        ]
        response.each do |dc|
          datacenters << dc['id']
          datacenters << dc['location']
          datacenters << dc['country_code']
        end

        puts ui.list(datacenters, :uneven_columns_across, 3)
      end
    end
  end
end
