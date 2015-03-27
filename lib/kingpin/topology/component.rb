module Kingpin
  module Topology
    class Component
      attr_reader :name, :options
      attr_accessor :parent
      def initialize(name, options={})
        @name, @options = name, options
      end

      def topology
        @parent.topology
      end

      def template
        @parent.template
      end
    end
  end
end
