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
      if task = configuration.find(name)
        task.new.run *args
      else
        super
      end
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
  end
end
