module Kingpin
  module Dsl
    class TaskReader
      include Kingpin::DslHelper

      attr_reader :tasks
      def initialize(name, &block)
        @name  = name
        @type  = :action
        @tasks = []
        instance_eval &block
      end

      def action(&block)
        if @type == :sequence
          raise ArgumentError, 'cant combine action and sequence in the same task'
        end
        @action = block
      end

      def task(name, &block)
        @tasks << self.class.new(name, &block).read
      end

      def run(name, &block)
        @tasks << _build_task(name, block)
      end

      def sequence(&block)
        if @action
          raise ArgumentError, 'cant combine action and sequence in the same task'
        end
        @type  = :sequence
        @tasks = self.class.new(@name, &block).tasks
      end

      def on_abort(&block)
        @on_abort = block
      end

      def include_task(name)
        @tasks << _build_task_reference(name)
      end

      def read
        if @action.nil? and @tasks.empty?
          raise ArgumentError, "Task #{@name} is MIA"
        end

        if @type == :sequence
          _build_sequence(@name, @tasks)
        else
          _build_task(@name, @action)
        end
      end

      private
        def _build_task_reference(name)
          klass = Class.new(Kingpin::TaskReference)
          klass.instance_variable_set(:@name, name)
          klass
        end

        def _build_task(name, action)
          klass = Class.new(Kingpin::Task)
          klass.send :define_method, :action, &action
          klass.instance_variable_set(:@name, name)
          klass
        end

        def _build_sequence(name, sequence)
          klass = Class.new(Kingpin::TaskSequence)
          klass.instance_variable_set(:@sequence, sequence)
          klass.instance_variable_set(:@name, name)
          klass
        end
    end
  end
end
