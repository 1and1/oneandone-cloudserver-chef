require 'chef/knife/oneandone_base'
require '1and1/helpers'

class Chef
  class Knife
    class OneandoneSshKeyCreate < Knife
      include Knife::OneandoneBase
      include Oneandone::Helpers

      banner 'knife oneandone ssh key create (options)'

      option :name,
             short: '-n NAME',
             long: '--name NAME',
             description: 'SSH Key name (required)'

      option :description,
             long: '--description DESCRIPTION',
             description: 'SSH Key description'

      option :public_key,
             short: '-p PUBLIC_KEY',
             long: '--public-key PUBLIC_KEY',
             description: 'Public key to import. If not given, new SSH key pair will be created'\
                          ' and the private key is returned in the response.'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        validate(config[:name], '-n NAME')

        init_client

        ssh_key = OneAndOne::SshKey.new
        response = ssh_key.create(name: config[:name], description: config[:description],
                                  public_key: config[:public_key])

        if config[:wait]
          ssh_key.wait_for
          formated_output(ssh_key.get, true)
          puts "SSH Key #{response['id']} is #{ui.color('created', :bold)}"
        else
          formated_output(response, true)
          puts "SSH Key #{response['id']} is #{ui.color('being created', :bold)}"
        end
      end
    end
  end
end
