module Kingpin
  class CommandLine
    def initialize(args)
      parse args
    end

    def run
      
    end

    private
      def options
        @options ||= begin
          result = OpenStruct.new
          result.address = '0.0.0.0'
          result.port    = 80
          result.options = []
          result
        end
      end

      def parse(args)
        options = {}
        OptionParser.new do |opts|
          opts.on('--address=ADDRESS', 'address to listen on') do |o|
            options.address = o
          end

          opts.on('--port=PORT', 'port to listen on') do |o|
            options.port = o
          end

          opts.on('-c', '--config=CONFIG', 'where to get the config') do |o|
            options.config = o
          end

          opts.on('-s', '--ssh_key=SSH', 'where to find the ssh key (optional)') do |o|
            options.ssh_key = o
          end

          opts.on('-o OPTION', 'where to get the config') do |o|
            options.options << o
          end

          opts.on('-i', '--initial=INITIAL', 'where to get the config') do |o|
            options.initial = o
          end
        end.parse!(args)
      end
  end
end
