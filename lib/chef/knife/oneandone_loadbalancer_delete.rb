require 'chef/knife/oneandone_base'

class Chef
  class Knife
    class OneandoneLoadbalancerDelete < Knife
      include Knife::OneandoneBase

      banner 'knife oneandone loadbalancer delete LOAD_BALANCER_ID [LOAD_BALANCER_ID] (options)'

      option :wait,
             short: '-W',
             long: '--wait',
             description: 'Wait for the operation to complete.'

      def run
        $stdout.sync = true

        init_client

        name_args.each do |load_balancer_id|
          load_balancer = OneAndOne::LoadBalancer.new

          begin
            load_balancer.get(load_balancer_id: load_balancer_id)
          rescue StandardError => e
            if e.message.include? 'NOT_FOUND'
              ui.error("Load balancer ID #{load_balancer_id} not found. Skipping.")
            else
              ui.error(e.message)
            end
            next
          end

          load_balancer_name = load_balancer.specs['name']

          confirm("Do you really want to delete load_balancer policy '#{load_balancer_name}'")

          load_balancer.delete

          if config[:wait]
            begin
              puts ui.color('Deleting, wait for the operation to complete...', :cyan).to_s
              load_balancer.wait_for
              puts "Load balancer '#{load_balancer_name}' is #{ui.color('deleted', :bold)}"
            rescue StandardError => e
              if e.message.include? 'NOT_FOUND'
                puts "Load balancer '#{load_balancer_name}' is #{ui.color('deleted', :bold)}"
              else
                ui.error(e.message)
              end
            end
          else
            puts "Load balancer '#{load_balancer_name}' is #{ui.color('being deleted', :bold)}"
          end
        end
      end
    end
  end
end
