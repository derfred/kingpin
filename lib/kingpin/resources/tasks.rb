module Kingpin
  module Resources
    class Tasks < Base
      def allowed_methods
        ['GET','POST']
      end

      private
        def tasks
          configuration.tasks
        end

        def jobs
          registry.all(Kingpin::Job)
        end

        def to_html
          render 'tasks.haml'
        end
    end
  end
end
