module Kingpin
  module Tasks
    class CreateAndWait < Kingpin::Task
      Kingpin::Configuration.register_task self

      def self.name
        :create_and_wait
      end

      def action(component, params)
        puts component.template.evaluate(component, params).inspect
      end
    end
  end
end
