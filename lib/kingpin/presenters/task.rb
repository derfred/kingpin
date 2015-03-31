module Kingpin
  module Presenters
    class Task < Base
      def initialize(task)
        @task = task
      end

      def serializable_hash(options=nil)
        {
          :name        => @task.name,
          :description => @task.description
        }
      end
    end
  end
end
