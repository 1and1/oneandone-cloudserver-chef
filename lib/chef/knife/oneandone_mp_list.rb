require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneMpList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone mp list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::MonitoringPolicy.new.list
        formated_output(response, true)

        mp_list = [
          ui.color('ID', :bold),
          ui.color('Name', :bold),
          ui.color('Email', :bold),
          ui.color('State', :bold),
          ui.color('Agent', :bold)
        ]
        response.each do |mp|
          mp_list << mp['id']
          mp_list << mp['name']
          mp_list << mp['email']
          mp_list << mp['state']
          mp_list << mp['agent'].to_s
        end

        puts ui.list(mp_list, :uneven_columns_across, 5)
      end
    end
  end
end
