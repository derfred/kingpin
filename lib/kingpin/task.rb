module Kingpin
  class Task
    include Celluloid
    include Celluloid::Notifications

    trap_exit :receive_task_failure

    def initialize(uuid)
      @uuid = uuid
    end

    def self.name
      @name
    end

    def name
      self.class.name
    end

    def self.description
      @description
    end

    def run(*params)
      log "executing #{name}"
      start
      @tasks = {}
      if method(:action).arity == 0
        action
      else
        action *params
      end
      wait_for_async_tasks
      finish
    end

    def method_missing(name, *args, &block)
      run_task(:async, name, *args) || super
    end

    def receive_task_notification(topic, payload)
      case payload[:event]
      when :finish
        @tasks.delete(payload[:task_id]).terminate
      when :log
        payload[:path] += [@uuid]
        publish "task_#{@uuid}", payload
      end
    end

    def receive_task_failure(actor, reason)
      if reason
        log "sub task failed #{reason.inspect}"
        publish "task_#{@uuid}", :event => :failure
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

      def start
        @start = Time.now
      end

      def finish
        log "completed #{name} in #{Time.now-@start}s"
        publish "task_#{@uuid}", :task_id => @uuid, :event => :finish, :time => Time.now-@start
      end

      def log(msg, data={})
        publish "task_#{@uuid}", :path => [@uuid], :event => :log, :msg => msg, :data => data
      end

      def wait_for_async_tasks
        while !@tasks.empty? and @tasks.values.all?(&:alive?)
          sleep 0.1
        end
      end

      def run_task(mode, name, *args)
        if task_class = configuration.find(name)
          run_task_class(mode, task_class, *args)
          true
        else
          false
        end
      end

      def run_task_class(mode, klass, *args)
        id         = SecureRandom.uuid
        subscribe "task_#{id}", :receive_task_notification

        @tasks   ||= {}
        @tasks[id] = klass.new_link id
        if mode == :async
          @tasks[id].async.run *args
        else
          @tasks[id].run *args
        end
      end
  end
end
