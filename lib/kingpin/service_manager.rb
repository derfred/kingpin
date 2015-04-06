module Kingpin
  class ServiceManager
    include Celluloid
    include Celluloid::Notifications

    trap_exit :task_exit

    def initialize
      @services = []
    end

    def run_services(services, *params)
      stop_services
      start_services services
    end

    private
      def stop_services
        @services.each(&:stop)
      end

      def start_services(services, *params)
        @services = services.map { |s| Kingpin::ServiceRunner.new_link(s, *params).async.start }
      end
  end
end
