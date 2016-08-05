require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneApplianceList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone appliance list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::ServerAppliance.new.list
        formated_output(response, true)

        sizes = [
          ui.color('ID', :bold),
          ui.color('Name', :bold),
          ui.color('Type', :bold),
          ui.color('OS', :bold),
          ui.color('Version', :bold),
          ui.color('Architecture', :bold)
        ]
        response.each do |fs|
          sizes << fs['id']
          sizes << fs['name']
          sizes << fs['type']
          sizes << fs['os']
          sizes << fs['version']
          sizes << fs['os_architecture'].to_s
        end

        puts ui.list(sizes, :uneven_columns_across, 6)
      end
    end
  end
end
