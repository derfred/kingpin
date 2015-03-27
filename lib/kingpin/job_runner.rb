module Kingpin
  class JobRunner
    include Celluloid

    def run(task, *params)
      job = Kingpin::Job.new task, params
      Celluloid::Actor[:registry].put job

      task_instance = task.new
      task_instance.run *params
    end
  end
end
