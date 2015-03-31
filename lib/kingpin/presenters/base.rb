require 'active_support/core_ext/class/attribute'
require 'active_support/concern'
require 'active_model/naming'
require 'active_model/serialization'
require 'active_model/serializers/json'

module Kingpin
  module Presenters
    class Base
      include ActiveModel::Serializers::JSON
    end
  end
end
