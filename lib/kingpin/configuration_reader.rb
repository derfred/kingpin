module Kingpin
  class ConfigurationReader
    def initialize(filename, options)
      @options = options
      @tasks   = []
      instance_eval File.read(filename), filename, 0
    end

    def draw_topology(&block)
      @topology = Kingpin::TopologyReader.new(&block).read
    end

    def task(name, &block)
      @tasks << Kingpin::TaskReader.new(name, &block).read
    end

    def read
      Kingpin::Configuration.new(@topology, @tasks)
    end
  end
end
