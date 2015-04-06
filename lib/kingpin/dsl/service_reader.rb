module Kingpin
  module Dsl
    class ServiceReader
      include Kingpin::DslHelper

      def initialize(name, &block)
        @name  = name
        eval_dsl_block &block
      end

      def description=(description)
        @description = description
      end

      def description(description)
        @description = description
      end

      def action(&block)
        @action = block
      end

      def schedule(options)
        @schedule = options
      end

      def read
        klass = Class.new(Kingpin::Service)
        klass.send :define_method, :action, &@action
        klass.instance_variable_set(:@name, @name)
        klass.instance_variable_set(:@description, @description)
        klass.instance_variable_set(:@schedule, @schedule)
        klass
      end
    end
  end
end
