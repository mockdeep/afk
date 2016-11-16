# frozen_string_literal: true
require 'configurator'

module AFK
  # Configuration class
  class Configuration

    include Configurator

    config :project_signifier
    config :task_signifier

  end
end
