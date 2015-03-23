module Kingpin
  module Resources
    class Base < Webmachine::Resource
      include Kingpin::RenderHelper

      def registry
        Kingpin::Application.instance.registry
      end

      def configuration
        Kingpin::Application.instance.configuration
      end
    end
  end
end
