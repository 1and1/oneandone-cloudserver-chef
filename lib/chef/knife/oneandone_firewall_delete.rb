require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneFirewallDelete < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone firewall delete FIREWALL_ID [FIREWALL_ID] (options)'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        init_client

        name_args.each do |firewall_id|
          firewall = OneAndOne::Firewall.new

          begin
            firewall.get(firewall_id: firewall_id)
          rescue StandardError => e
            if e.message.include? 'NOT_FOUND'
              ui.error("Firewall ID #{firewall_id} not found. Skipping.")
            else
              ui.error(e.message)
            end
            next
          end

          firewall_name = firewall.specs['name']

          confirm("Do you really want to delete firewall policy '#{firewall_name}'")

          firewall.delete

          if config[:wait]
            begin
              puts ui.color('Deleting, wait for the operation to complete...', :cyan).to_s
              firewall.wait_for
              puts "Firewall policy '#{firewall_name}' is #{ui.color('deleted', :bold)}"
            rescue StandardError => e
              if e.message.include? 'NOT_FOUND'
                puts "Firewall policy '#{firewall_name}' is #{ui.color('deleted', :bold)}"
              else
                ui.error(e.message)
              end
            end
          else
            puts "Firewall policy '#{firewall_name}' is #{ui.color('being deleted', :bold)}"
          end
        end
      end
    end
  end
end
