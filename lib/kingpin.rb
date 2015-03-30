require 'celluloid'
require 'webmachine'
require 'kubeclient'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/numeric/time'

module Kingpin
  def self.application
    Kingpin::Application.instance
  end
end

%w{render_helper web_server_builder task task_sequence task_reference job configuration template registry job_runner application dsl_helper}.each do |f|
  require "kingpin/#{f}"
end

%w{configuration_reader task_reader group_reader topology_reader service_reader kubernetes_pod_template_reader kubernetes_pod_template_container_reader kubernetes_replication_controller_reader kubernetes_service_reader}.each do |f|
  require "kingpin/dsl/#{f}"
end

%w{group component topology}.each do |f|
  require "kingpin/topology/#{f}"
end

%w{base home task tasks job}.each do |f|
  require "kingpin/resources/#{f}"
end

%w{create_and_wait}.each do |f|
  require "kingpin/tasks/#{f}"
end

