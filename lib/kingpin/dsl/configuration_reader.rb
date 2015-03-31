module Kingpin
  module Dsl
    class ConfigurationReader
      include Kingpin::DslHelper

      def initialize(filename)
        @tasks    = []
        @services = []
        instance_eval File.read(filename), filename, 0
      end

      def topology(&block)
        @topology = Kingpin::Dsl::TopologyReader.new(&block).read
      end

      def task(name, &block)
        @tasks << Kingpin::Dsl::TaskReader.new(name, &block).read
      end

      def service(name, &block)
        @services << Kingpin::Dsl::ServiceReader.new(name, &block).read
      end

      def read
        Kingpin::Configuration.new(@topology, @tasks, @services)
      end
    end
  end
end
