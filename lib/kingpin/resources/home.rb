module Kingpin
  module Resources
    class Home < Webmachine::Resource
      def allowed_methods
        ['GET','HEAD']
      end
    end
  end
end
