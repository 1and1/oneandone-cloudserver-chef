require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneSshKeyDelete < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone ssh key delete SSH_KEY_ID [SSH_KEY_ID] (options)'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        init_client

        name_args.each do |ssh_key_id|
          ssh_key = OneAndOne::SshKey.new

          begin
            ssh_key.get(ssh_key_id: ssh_key_id)
          rescue StandardError => e
            if e.message.include? 'NOT_FOUND'
              ui.error("SSH key ID #{ssh_key_id} not found. Skipping.")
            else
              ui.error(e.message)
            end
            next
          end

          ssh_key_name = ssh_key.specs['name']

          confirm("Do you really want to delete SSH key '#{ssh_key_name}'")

          ssh_key.delete

          if config[:wait]
            begin
              puts ui.color('Deleting, wait for the operation to complete...', :cyan).to_s
              ssh_key.wait_for
              puts "SSH key '#{ssh_key_name}' is #{ui.color('deleted', :bold)}"
            rescue StandardError => e
              if e.message.include? 'NOT_FOUND'
                puts "SSH key '#{ssh_key_name}' is #{ui.color('deleted', :bold)}"
              else
                ui.error(e.message)
              end
            end
          else
            puts "SSH key '#{ssh_key_name}' is #{ui.color('being deleted', :bold)}"
          end
        end
      end
    end
  end
end
