module Kingpin
  class Service < Task
    def self.scheduled_every
      @schedule[:every]
    end
  end
end
