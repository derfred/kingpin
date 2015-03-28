module Kingpin
  class TaskReference < Task
    def run(*params)
      run_task :sync, self.class.name, *params
    end
  end
end
