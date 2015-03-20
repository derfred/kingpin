module Kingpin
  module Resources
    class Tasks < Webmachine::Resource
      include Kingpin::RenderHelper

      def allowed_methods
        ['GET','POST']
      end

      private
        def to_html
          render 'tasks.haml'
        end
    end
  end
end
