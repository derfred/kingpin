module Kingpin
  class Registry
    include Celluloid

    def initialize
      @store = {}
    end

    def all(klass)
      (@store[klass] || {}).values
    end

    def get(klass, id)
      (@store[klass] || {})[id]
    end

    def put(obj)
      @store[obj.class] ||= {}
      @store[obj.class][obj.id] = obj
    end
  end
end
