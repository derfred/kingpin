module Kingpin
  module Dsl
    class KubernetesPodTemplateReader
      include Kingpin::DslHelper

      attr_accessor :labels
      def initialize(&block)
        @containers = []
        eval_dsl_block &block
      end

      def container(&block)
        @containers << Kingpin::Dsl::KubernetesPodTemplateContainerReader.new(&block).read
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
