module Kingpin
  class TaskReference < Task
    def run(*params)
      run_task self.class.name, *params
    end
  end
end
