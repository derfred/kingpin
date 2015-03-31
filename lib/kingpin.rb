require 'celluloid'
require 'kubeclient'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/numeric/time'

module Kingpin
  def self.application
    Kingpin::Application.instance
  end

  def self.registry
    Celluloid::Actor[:registry]
  end

  def self.service_manager
    Celluloid::Actor[:service_manager]
  end
end

%w{render_helper task task_sequence task_reference job configuration template registry job_runner service_manager service_runner application dsl_helper}.each do |f|
  require "kingpin/#{f}"
end

%w{configuration_reader task_reader group_reader topology_reader service_reader kubernetes_pod_template_reader kubernetes_pod_template_container_reader kubernetes_replication_controller_reader kubernetes_service_reader}.each do |f|
  require "kingpin/dsl/#{f}"
end

%w{base tasks task jobs job}.each do |f|
  require "kingpin/presenters/#{f}"
end

%w{group component topology}.each do |f|
  require "kingpin/topology/#{f}"
end

%w{create_and_wait}.each do |f|
  require "kingpin/tasks/#{f}"
end
