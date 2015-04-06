require 'timers'

module Kingpin
  class ServiceRunner < JobRunner
    include Celluloid
    include Celluloid::Notifications

    trap_exit :task_exit

    def initialize(service, *params)
      @service = service
      @params  = params
      @timers  = Timers::Group.new
    end

    def start
      @running = true
      @timer   = @timers.every(@service.scheduled_every) do
        run @service, @params
      end
      while @running
        @timers.wait
      end
    end

    def stop
      @running = true
      @timer.cancel
    end

    def task_exit(actor, reason)
      puts "exit #{actor.inspect} #{reason.inspect}"
    end
  end
end
