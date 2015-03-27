module Kingpin
  module Dsl
    class TopologyReader < GroupReader
      def initialize(&block)
        @groups     = []
        @components = []
        instance_eval &block
      end

      def read
        result = Kingpin::Topology::Topology.new @groups, @components, @template_class
        (@groups + @components).each { |c| c.parent = result }
        result
      end
    end
  end
end
