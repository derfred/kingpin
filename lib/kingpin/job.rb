module Kingpin
  class Job
    attr_reader :id, :task, :params, :state

    def initialize(task, params)
      @task   = task
      @params = params
      @id     = SecureRandom.uuid
    end

    def name
      @task.name
    end
  end
end
