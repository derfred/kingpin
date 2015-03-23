require 'haml'

module Kingpin
  module RenderHelper
    def render(file)
      build_engine = proc do |fname|
        relative = File.join("/assets/views/", fname)
        Haml::Engine.new(File.read(File.join(File.dirname(__FILE__), relative)), :filename => relative)
      end

      template = build_engine.call(file)
      layout   = build_engine.call('layout.haml')
      layout.render(self) do
        template.render(self)
      end
    end
  end
end
