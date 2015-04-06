module Kingpin
  module Tasks
    class CreateAndWait < Kingpin::Task
      Kingpin::Configuration.register_task self

      def self.name
        :create_and_wait
      end

      def action(component, params)
        log "starting component #{component.name}"

        template = component.template_class.new
        template.evaluate(component, params)

        replication_controllers = []
        template.replication_controllers.each do |rc|
          client.create_replication_controller(rc)
          replication_controllers << rc.metadata.name
        end

        template.services.each do |se|
          client.create_service(se)
        end

        wait_for_replication_controllers replication_controllers
      end

      private
        def wait_for(_timeout=60, ignored_exceptions=[], &block)
          timeout(_timeout) do
            while true
              begin
                return if yield
              rescue Exception => e
                unless [ignored_exceptions].flatten.any? { |i| e.is_a?(i) }
                  raise
                end
              end
              sleep 0.1
            end
          end
        end

        def wait_for_replication_controllers(controllers, timeout=320)
          start = Time.now.to_i
          wait_for(timeout) do
            controllers.all? do |name|
              replication_controller_ready?(name)
            end
          end
        end

        def replication_controller_ready?(name)
          controller = client.get_replication_controller(name)
          return false unless controller.spec.replicas == controller.status.replicas

          client.get_pods(controller.spec.selector.to_hash).all? do |p|
            p.status.info && p.status.info.to_hash.values.all? { |v| v['ready'] }
          end
        end
    end
  end
end
