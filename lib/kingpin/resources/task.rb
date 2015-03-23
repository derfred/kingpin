module Kingpin
  module Resources
    class Task < Base
      def allowed_methods
        ['GET']
      end

      private
        def to_html
          render 'task.haml'
        end
    end
  end
end
