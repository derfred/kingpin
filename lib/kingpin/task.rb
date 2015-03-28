module Kingpin
  class Task
    def self.name
      @name
    end

    def self.description
      @description
    end

    def run(*params)
      if method(:action).arity == 0
        action
      else
        action *params
      end
    end

    def method_missing(name, *args, &block)
      run_task(name, *args) || super
    end

    private
      def client
        @client ||= Kubeclient::Client.new('http://kubo1.meeting-masters.eu:8080/api', "v1beta3")
      end

      def configuration
        Kingpin.application.configuration
      end

      def topology
        configuration.topology
      end

      def run_task(name, *args)
        if task = configuration.find(name)
          task.new.run *args
          true
        else
          false
        end
      end
  end
end
