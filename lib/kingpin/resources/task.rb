module Kingpin
  module Resources
    class Task < Webmachine::Resource
      include Kingpin::RenderHelper

      private
        def to_html
          render 'task.haml'
        end
    end
  end
end
