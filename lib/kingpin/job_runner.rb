module Kingpin
  class JobRunner
    include Celluloid
    include Celluloid::Notifications

    trap_exit :task_exit

    def run(task, *params)
      @job = Kingpin::Job.new task, params
      Celluloid::Actor[:registry].put @job

      subscribe "task_#{@job.id}", :receive_task_notification
      task_instance = task.new_link @job.id
      task_instance.run *params

      @job = nil
    end

    def task_exit(actor, reason)
      puts "exit #{actor.inspect} #{reason.inspect}"
    end

    def receive_task_notification(topic, payload)
      puts "receive #{payload.inspect}"
    end
  end
end
