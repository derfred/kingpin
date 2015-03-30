module Kingpin
  class Template
    attr_reader :replication_controllers, :services, :pods
    def initialize
      @replication_controllers = []
      @services                = []
      @pods                    = []
    end

    def evaluate(component, params)
      translate component, params
    end

    def replication_controller(&block)
      @replication_controllers << Kingpin::Dsl::KubernetesReplicationControllerReader.new(&block).read
    end

    def service(&block)
      @services << Kingpin::Dsl::KubernetesServiceReader.new(&block).read
    end

    def pod(&block)
      @pods << Kingpin::Dsl::KubernetesPodReader.new(&block).read
    end
  end
end
