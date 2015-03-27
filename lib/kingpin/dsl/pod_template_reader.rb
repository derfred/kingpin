module Kingpin
  module Dsl
    class PodTemplateReader
      include Kingpin::DslHelper

      attr_accessor :labels
      def initialize(&block)
        @containers = []
        eval_dsl_block &block
      end

      def container(&block)
        @containers << Kingpin::Dsl::PodTemplateContainerReader.new(&block).read
      end

      def read
        {
          :metadata => {
            :labels => @labels
          },
          :spec => {
            :containers => @containers
          }
        }
      end
    end
  end
end
