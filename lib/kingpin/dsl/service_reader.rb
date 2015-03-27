module Kingpin
  module Dsl
    class ServiceReader
      include Kingpin::DslHelper

      attr_accessor :name, :labels, :selector
      def initialize(&block)
        eval_dsl_block &block
      end

      def spec(options)
        @spec = options
      end

      def read
        hash = {
          :kind       => "Service",
          :namespace  => "default",
          :apiVersion => "v1beta3",
          :metadata => {
            :name   => @name,
            :labels => @labels
          },
          :spec => @spec.merge(@selector)
        }
        Service.new(hash)
      end
    end
  end
end
