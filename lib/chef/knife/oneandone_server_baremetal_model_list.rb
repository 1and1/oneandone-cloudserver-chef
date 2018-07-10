require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneBaremetalModelList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone baremetal model list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::Server.new.list_baremetal_models
        formated_output(response, true)

        baremetal_model_list = [
            ui.color('ID', :bold),
            ui.color('Name', :bold)
        ]
        response.each do |baremetal_model|
          baremetal_model_list << baremetal_model['id']
          baremetal_model_list << baremetal_model['name']
        end

        puts ui.list(baremetal_model_list, :uneven_columns_across, 2)
      end
    end
  end
end
