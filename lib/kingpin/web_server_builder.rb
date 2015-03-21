require 'webmachine'

module Kingpin
  class WebServerBuilder
    def build_application(options)
      Bootstrap.load!

      Webmachine::Application.new do |app|
        app.routes do
          add [''],           Kingpin::Resources::Home
          add ['tasks'],      Kingpin::Resources::Tasks
          add ['tasks', :id], Kingpin::Resources::Task
        end

        app.configure do |config|
          config.ip      = options.address
          config.port    = options.port
          config.adapter = :Reel
        end
      end
    end
  end
end
