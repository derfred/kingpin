require 'reel/rack'
require 'sinatra/base'
require 'sinatra/namespace'
require 'haml'

module Kingpin
  class WebServer < Sinatra::Base
    def self.build_application(options)
      hash = {
        :Host => options.address,
        :Port => options.port
      }
      ::Reel::Rack::Server.supervise_as(:reel_rack_server, new, hash)
    end

    register Sinatra::Namespace

    set :views, File.dirname(__FILE__) + "/assets/views"

    before do
      params.merge! json_body_params
    end

    helpers do
      def json_body_params
        @json_body_params ||= begin
          MultiJson.load(request.body.read.to_s, symbolize_keys: true)
        rescue MultiJson::LoadError
          {}
        end
      end
    end

    get '/' do
      @tasks = Kingpin.application.configuration.tasks
      @jobs  = Kingpin.registry.all(Kingpin::Job)
      haml :home
    end

    get '/jobs/:id' do
      @job = Kingpin.registry.get(Kingpin::Job, params[:id])
      haml :job
    end

    # API
    namespace '/api/v1' do
      namespace '/tasks' do
        get do
          Kingpin::Presenters::Tasks.new.to_json
        end

        get '/:id' do
          task = Kingpin.application.configuration.find(params[:id])
          Kingpin::Presenters::Task.new(task).to_json
        end

        get '/:id/last_job' do
          
        end

        get '/:id/jobs' do
          
        end

        post '/:id/start' do
          
        end
      end

      namespace '/jobs' do
        get do
          Kingpin::Presenters::Jobs.new.to_json
        end

        get '/:id' do
          job = Kingpin.registry.get(Kingpin::Job, params[:id])
          Kingpin::Presenters::Job.new(job).to_json
        end

        delete '/:id' do
          
        end
      end
    end

  end
end
