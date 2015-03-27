module Kingpin
  module Dsl
    class ConfigurationReader
      include Kingpin::DslHelper

      def initialize(filename, options)
        @options = options
        @tasks   = []
        instance_eval File.read(filename), filename, 0
      end

      def topology(&block)
        @topology = Kingpin::Dsl::TopologyReader.new(&block).read
      end

      def task(name, &block)
        @tasks << Kingpin::Dsl::TaskReader.new(name, &block).read
      end

      def read
        Kingpin::Configuration.new(@topology, @tasks)
      end
    end
  end
end
