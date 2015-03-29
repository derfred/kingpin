module Kingpin
  class JobRunner
    include Celluloid
    include Celluloid::Notifications

    trap_exit :task_exit

    def run(task, *params)
      @job = Kingpin::Job.new task, params
      @job.start
      Celluloid::Actor[:registry].put @job

      subscribe "task_#{@job.id}", :receive_task_notification
      task_instance = task.new_link @job.id
      task_instance.run *params

      unless @job.state == :failure
        @job.finish
        Celluloid::Actor[:registry].put @job
      end

      @job = nil
    end

    def task_exit(actor, reason)
      puts "exit #{actor.inspect} #{reason.inspect}"
    end

    def receive_task_notification(topic, payload)
      case payload[:event]
      when :log
        path = payload[:path][0...-1].reverse
        @job.add_log path, payload[:msg]
        Celluloid::Actor[:registry].put @job
      end
    end
  end
end
