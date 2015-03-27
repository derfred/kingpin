module Kingpin
  module Resources
    class Base < Webmachine::Resource
      include Kingpin::RenderHelper

      def registry
        Celluloid::Actor[:registry]
      end

      def configuration
        Kingpin::Application.instance.configuration
      end
    end
  end
end
