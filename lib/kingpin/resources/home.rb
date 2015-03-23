module Kingpin
  module Resources
    class Home < Base
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
