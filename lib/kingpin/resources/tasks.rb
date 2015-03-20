module Kingpin
  module Resources
    class Tasks < Webmachine::Resource
      def allowed_methods
        ['GET','HEAD']
      end
    end
  end
end
