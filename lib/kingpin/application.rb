require 'optparse'
require 'ostruct'
require 'webmachine'

module Kingpin
  class Application
    def self.instance
      @instance
    end

    def self.run(args)
      @instance = new(args)
      @instance.run
    end

    attr_reader :configuration

    def initialize(args)
      parse args

      @configuration = load_config
      @job_runner    = Kingpin::JobRunner.pool :size => settings.max_jobs
      Kingpin::Registry.supervise_as :registry
      Kingpin::ServiceManager.supervise_as :service_manager
    end

    def options
      settings.options
    end

    def run
      Celluloid.start

      if settings.initial
        task = configuration.find(settings.initial)
        raise ArgumentError if task.nil?
        if server_mode?
          @job_runner.async.run task, settings.options
        else
          @job_runner.run task, settings.options
        end
      end

      if server_mode?
        Kingpin.service_manager.async.run_services configuration.services
        run_webserver
      end
    end

    private
      def server_mode?
        !! settings.port
      end

      def settings
        @settings ||= begin
          result = OpenStruct.new
          result.address   = '0.0.0.0'
          result.options   = ActiveSupport::HashWithIndifferentAccess.new
          result.max_tasks = 10
          result
        end
      end

      def parse(args)
        OptionParser.new do |opts|
          opts.on('--address=ADDRESS', 'address to listen on') do |o|
            settings.address = o
          end

          opts.on('--port=PORT', 'port to listen on') do |o|
            settings.port = o
          end

          opts.on('-c', '--config=CONFIG', 'where to get the config') do |o|
            settings.config = o
          end

          opts.on('-s', '--ssh_key=SSH', 'where to find the ssh key (optional)') do |o|
            settings.ssh_key = o
          end

          opts.on('-o OPTION', 'where to get the config') do |o|
            k, v = o.split('=')
            settings.options[k] = v
          end

          opts.on('-i', '--initial=INITIAL', 'where to get the config') do |o|
            settings.initial = o
          end
        end.parse!(args)

        raise OptionParser::MissingArgument, '-c/--config' if settings.config.nil?
      end

      def load_config
        Kingpin::Dsl::ConfigurationReader.new(settings.config).read
      end

      def run_webserver
        require 'kingpin/web_server'
        supervisor = Kingpin::WebServer.build_application(settings)
        begin
          sleep
        rescue Interrupt
          Celluloid.logger.info "Interrupt received... shutting down"
          supervisor.terminate
        end
      end
  end
end
