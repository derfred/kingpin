module Kingpin
  module Dsl
    class GroupReader
      include Kingpin::DslHelper

      def initialize(name, &block)
        @name       = name
        @groups     = []
        @components = []
        eval_dsl_block &block
      end

      def component(name, options={})
        @components << Kingpin::Topology::Component.new(name, options)
      end

      def group(name, &block)
        @groups << Kingpin::Dsl::GroupReader.new(name, &block).read
      end

      def template(&block)
        @template_class = Class.new(Kingpin::Template) do
          define_method :translate, &block
        end
      end

      def template_class(&block)
        @template_class = Class.new(Kingpin::Template, &block)
      end

      def read
        result = Kingpin::Topology::Group.new(@name, @groups, @components, @template_class)
        (@groups + @components).each { |c| c.parent = result }
        result
      end
    end
  end
end
