module Kingpin
  module Dsl
    class ServiceReader
      include Kingpin::DslHelper

      def initialize(name, &block)
        @name  = name
        eval_dsl_block &block
      end

      def action(&block)
        @action = block
      end

      def schedule(options)
        @schedule = options
      end

      def read
        
      end
    end
  end
end
