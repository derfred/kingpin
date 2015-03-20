module Kingpin
  module Resources
    class Home < Webmachine::Resource
      include Kingpin::RenderHelper

      def allowed_methods
        ['GET','HEAD']
      end

      private
        def to_html
          render 'home.haml'
        end
    end
  end
end
