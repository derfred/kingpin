module Kingpin
  module Presenters
    class Tasks < Base
      def as_json(options=nil)
        Kingpin::Application.instance.configuration.tasks.map do |task|
          Kingpin::Presenters::Task.new task
        end.as_json
      end
    end
  end
end
