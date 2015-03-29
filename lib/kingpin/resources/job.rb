module Kingpin
  module Resources
    class Job < Base
      def allowed_methods
        ['GET']
      end

      private
        def job
          @job ||= registry.get(Kingpin::Job, request.path_info[:id])
        end

        def to_html
          render 'job.haml'
        end
    end
  end
end
