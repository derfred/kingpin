module Kingpin
  class TaskSequence < Task
    def self.sequence
      @sequence
    end

    def run(*args)
      start
      @tasks = {}
      self.class.sequence.each do |task_class|
        run_task_class(:sync, task_class, *args)
      end
      finish
    end
  end
end
