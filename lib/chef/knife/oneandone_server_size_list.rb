require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneServerSizeList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone server size list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::Server.new.list_fixed
        formated_output(response, true)

        sizes = [
          ui.color('ID', :bold),
          ui.color('Name', :bold),
          ui.color('RAM (GB)', :bold),
          ui.color('Processor No.', :bold),
          ui.color('Cores per Processor', :bold),
          ui.color('Disk Size (GB)', :bold)
        ]
        response.each do |fs|
          sizes << fs['id']
          sizes << fs['name']
          sizes << fs['hardware']['ram'].to_s
          sizes << fs['hardware']['vcore'].to_s
          sizes << fs['hardware']['cores_per_processor'].to_s
          sizes << fs['hardware']['hdds'][0]['size'].to_s
        end

        puts ui.list(sizes, :uneven_columns_across, 6)
      end
    end
  end
end
