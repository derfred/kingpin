module Kingpin
  module Dsl
    class KubernetesPodTemplateContainerReader
      include Kingpin::DslHelper

      attr_accessor :name, :image, :liveness_probe
      def initialize(&block)
        @env   = []
        @ports = []
        eval_dsl_block &block
      end

      def env(options)
        @env << options
      end

      def port(options)
        @ports << options
      end

      def read
        result = {
          :name  => @name,
          :image => @image,
          :ports => @ports,
          :env   => @env
        }
        result[:livenessProbe] = @liveness_probe if @liveness_probe
        result
      end
    end
  end
end
