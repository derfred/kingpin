require 'rubygems'
require 'bundler/setup'
require 'reel'
require 'webmachine'
require 'webmachine/trace'
require 'securerandom'

addr, port = '127.0.0.1', 1234

module Models
  class Task
    include Celluloid

    def self.save(task)
      @store ||= {}
      @store[task.id] = task
    end

    def self.all
      (@store ||= {}).values
    end

    def initialize(params={})
      @params = {}
      @params[:id]    ||= SecureRandom.uuid
      @params[:state] ||= :started
    end

    def start
      self.class.save(self)

      @params[:state] = :running

      num = (rand*10).floor
      puts "[#{id}] doing #{num} iterations"
      num.times do |i|
        puts "[#{id}] iteration #{i}"
        sleep (rand*10).floor
      end

      @params[:state] = :done
    end

    def id
      @params[:id]
    end

    def state
      @params[:state]
    end

    def name
      @params[:name]
    end
  end
end

module Resources
  class Task < Webmachine::Resource
    def allowed_methods
      ['GET','HEAD']
    end

    def to_html
      "<html><body>Hello, world!</body></html>"
    end
  end

  class Tasks < Webmachine::Resource
    def trace?
      true
    end

    def allowed_methods
      ['GET','POST']
    end

    def content_types_accepted
      [["*/*", :from_json]]
    end

    def post_is_create?
      true
    end

    def create_path
      "/tasks/#{1}"
    end

    private
      def from_json
        task_from_request.async.start
        puts "after start"
        true
      end

      def to_html
        content = Models::Task.all.map do |task|
          [
            "<tr>",
              "<td>", task.id.to_s, "</td>",
              "<td>", task.name.to_s, "</td>",
              "<td>", task.state.to_s, "</td>",
            "</tr>"
          ]
        end.join
        "<html><body><table><thead><tr><td>id</td><td>name</td><td>state</td></tr></thead><tbody>#{content}</tbody></table></body></html>"
      end

      def task_from_request
        @task ||= Models::Task.new(params)
      end

      def params
        if request.body.to_s == ""
          {}
        else
          JSON.parse(request.body.to_s)
        end
      end
  end
end

MyApp = Webmachine::Application.new do |app|
  app.routes do
    add ['tasks'], Resources::Tasks
    add ['tasks', :id], Resources::Task
    add ['trace', :*], Webmachine::Trace::TraceResource
  end

  app.configure do |config|
    config.ip      = addr
    config.port    = port
    config.adapter = :Reel
  end
end

MyApp.run
