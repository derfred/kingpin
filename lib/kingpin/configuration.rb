module Kingpin
  class Configuration
    def self.register_task(klass)
      @tasks ||= []
      @tasks << klass
    end

    def self.tasks
      @tasks || []
    end

    attr_reader :topology, :tasks
    def initialize(topology, tasks)
      @topology, @tasks = topology, tasks
    end

    def find(name)
      task = @tasks.find { |t| t.name == name.to_sym }
      return task if task
      self.class.tasks.find { |t| t.name == name.to_sym }
    end
  end
end
