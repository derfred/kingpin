module Kingpin
  module Dsl
    class KubernetesReplicationControllerReader
      include Kingpin::DslHelper

      attr_accessor :name, :labels, :replicas, :selector
      def initialize(&block)
        @namespace = 'default'
        @replicas  = 1
        eval_dsl_block &block
      end

      def template(&block)
        @template = Kingpin::Dsl::KubernetesPodTemplateReader.new(&block).read
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

        rc = Kubeclient::ReplicationController.new(hash)
      end
    end
  end
end
