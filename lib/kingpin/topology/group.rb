module Kingpin
  module Topology
    class Group
      attr_reader :name, :template_class
      attr_accessor :parent
      def initialize(name, groups, components, template_class)
        @name, @groups, @components, @template_class = name.to_sym, groups, components, template_class
      end

      def topology
        @parent.topology
      end

      def template_class
        @template_class || @parent.template_class
      end

      def template
        template_class.new
      end

      def group(name)
        @groups.find { |g| g.name == name }
      end

      def each(&block)
        @components.each(&block)
      end
    end
  end
end
