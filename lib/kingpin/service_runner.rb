module Kingpin
  class ServiceRunner
    include Celluloid
    include Celluloid::Notifications

    trap_exit :task_exit

    def initialize(service)
      @service = service
    end
  end
end
