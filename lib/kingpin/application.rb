require 'webmachine'

Kingpin::Application = Webmachine::Application.new do |app|
  app.routes do
    add [''],           Kingpin::Resources::Home
    add ['tasks'],      Kingpin::Resources::Tasks
    add ['tasks', :id], Kingpin::Resources::Task
  end

  app.configure do |config|
    config.ip      = addr
    config.port    = port
    config.adapter = :Reel
  end
end
