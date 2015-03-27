module Kingpin
  module Dsl
    class ReplicationControllerReader
      include Kingpin::DslHelper

      attr_accessor :name, :labels, :replicas, :selector
      def initialize(&block)
        @namespace = 'default'
        @replicas  = 1
        eval_dsl_block &block
      end

      def template(&block)
        @template = Kingpin::Dsl::PodTemplateReader.new(&block).read
      end

      def read
        hash = {
          :kind       => "ReplicationController",
          :namespace  => @namespace,
          :apiVersion => 'v1beta3',
          :metadata   => {
            :name   => @name,
            :labels => @labels
          },
          :spec => {
            :replicas => @replicas,
            :selector => @selector,
            :template => @template
          }
        }

        rc = ReplicationController.new(hash)
      end
    end
  end
end
