module Kingpin
  class Task
    attr_reader :name
    attr_accessor :tasks, :action, :on_abort

    def initialize(name)
      @name  = name
      @tasks = []
    end
  end
end
