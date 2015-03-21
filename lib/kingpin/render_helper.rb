require 'haml'

module Kingpin
  module RenderHelper
    def render(file)
      template = Haml::Engine.new(File.read(File.join(File.dirname(__FILE__), "/assets/views/", file)))
      layout   = Haml::Engine.new(File.read(File.join(File.dirname(__FILE__), "/assets/views/layout.haml")))
      layout.render(self) do
        template.render(self)
      end
    end
  end
end
