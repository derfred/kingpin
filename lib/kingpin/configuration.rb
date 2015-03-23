module Kingpin
  class Configuration
    attr_reader :topology, :tasks
    def initialize(topology, tasks)
      @topology, @tasks = topology, tasks
    end

    def find(name)
      @tasks.find { |t| t.name == name }
    end
  end
end
