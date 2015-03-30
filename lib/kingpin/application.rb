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

    attr_reader :registry, :configuration

    def initialize(args)
      parse args

      @configuration = load_config
      @registry      = Kingpin::Registry.supervise_as :registry
      @job_runner    = Kingpin::JobRunner.pool :size => settings.max_jobs
    end

    def options
      settings.options
    end

    def run
      Celluloid.start

      if settings.initial
        task = configuration.find(settings.initial)
        raise ArgumentError if task.nil?
        @job_runner.async.run task, settings.options
      end

      web_server = Kingpin::WebServerBuilder.new.build_application(settings)
      web_server.run
    end

    private
      def settings
        @settings ||= begin
          result = OpenStruct.new
          result.address   = '0.0.0.0'
          result.port      = 80
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
        Kingpin::Dsl::ConfigurationReader.new(settings.config, settings.options).read
      end
  end
end
