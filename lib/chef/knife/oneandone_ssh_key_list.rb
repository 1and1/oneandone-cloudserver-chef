require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneSshKeyList < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone ssh key list'

      def run
        $stdout.sync = true

        init_client

        response = OneAndOne::SshKey.new.list
        formated_output(response, true)

        ssh_keys = [
          ui.color('ID', :bold),
          ui.color('Name', :bold),
          ui.color('Description', :bold),
          ui.color('State', :bold),
          ui.color('Servers', :bold),
          ui.color('Md5', :bold),
          ui.color('Public Key', :bold),
          ui.color('Creation Date', :bold)
        ]

        response.each do |ssh|
          ssh_keys << ssh['id']
          ssh_keys << ssh['name']
          ssh_keys << (ssh['description'].nil? ? '' : ssh['description'])
          ssh_keys << ssh['state']
          ssh_keys << ssh['servers'].to_s
          ssh_keys << ssh['md5']
          ssh_keys << ssh['public_key']
          ssh_keys << ssh['creation_date']
        end

        puts ui.list(ssh_keys, :uneven_columns_across, 8)
      end
    end
  end
end
