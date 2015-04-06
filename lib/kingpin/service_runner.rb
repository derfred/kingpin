module Kingpin
  class ServiceRunner
    include Celluloid
    include Celluloid::Notifications

    trap_exit :task_exit

    def initialize(service)
      @service = service
    end

    def task_exit(actor, reason)
      puts "exit #{actor.inspect} #{reason.inspect}"
    end
  end
end
