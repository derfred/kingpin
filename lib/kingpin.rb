require 'webmachine'

module Kingpin
  module Resources

  end
end

%w{sprockets_helper render_helper web_server_builder command_line}.each do |f|
  require "kingpin/#{f}"
end

%w{home task tasks}.each do |f|
  require "kingpin/resources/#{f}"
end
