require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneSshKeyRename < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone ssh key rename (options)'

      option :name,
             short: '-n NAME',
             long: '--name NAME',
             description: 'SSH Key name'

      option :description,
             long: '--description DESCRIPTION',
             description: 'SSH Key description'

      option :id,
             short: '-I ID',
             long: '--id ID',
             description: 'SSH Key ID'

      def run
        $stdout.sync = true

        init_client

        ssh_key = OneAndOne::SshKey.new
        response = ssh_key.modify(ssh_key_id: config[:id], name: config[:name], description: config[:description])

        formated_output(response, true)
        puts "SSH Key updated #{ui.color('updated', :bold)}"
      end
    end
  end
end
