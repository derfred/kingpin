module Kingpin
  class Job
    attr_reader :id, :task, :params, :state, :log

    def initialize(task, params)
      @task   = task
      @params = params
      @id     = SecureRandom.uuid
      @log    = []
    end

    def name
      @task.name
    end

    def add_log(path, msg)
      @log << { :path => path, :msg => msg, :time => Time.now }
    end

    def start
      @state = :running
      @start = Time.now
    end

    def finish
      @state  = :success
      @finish = Time.now
    end

    def fail
      @state  = :failure
      @finish = Time.now
    end
  end
end
