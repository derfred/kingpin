require 'celluloid'
require 'webmachine'

module Kingpin
  module Resources

  end
end

%w{render_helper web_server_builder job configuration registry application}.each do |f|
  require "kingpin/#{f}"
end

%w{base home task tasks}.each do |f|
  require "kingpin/resources/#{f}"
end
