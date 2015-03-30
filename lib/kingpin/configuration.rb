module Kingpin
  class Configuration
    def self.register_task(klass)
      @tasks ||= []
      @tasks << klass
    end

    def self.tasks
      @tasks || []
    end

    attr_reader :topology, :tasks, :services
    def initialize(topology, tasks, services)
      @topology, @tasks, @services = topology, tasks, services
    end

    def find(name)
      task = @tasks.find { |t| t.name == name.to_sym }
      return task if task
      self.class.tasks.find { |t| t.name == name.to_sym }
    end
  end
end
