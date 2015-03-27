module Kingpin
  module Topology
    class Topology < Group
      def initialize(groups, components, template_class)
        @groups, @components, @template_class = groups, components, template_class
      end

      def topology
        self
      end
    end
  end
end
