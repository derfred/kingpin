module Kingpin
  module Resources
    class Task < Webmachine::Resource
      include Kingpin::RenderHelper

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
