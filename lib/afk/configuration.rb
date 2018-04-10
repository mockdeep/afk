# frozen_string_literal: true

require 'configurator'

module AFK
  # Configuration class
  class Configuration

    include Configurator

    config :project_signifier
    config :task_signifier
    config :trello

    def initialize
      ::Trello.configure do |trello_config|
        trello_config.developer_public_key = trello.fetch(:developer_public_key)
        trello_config.member_token = trello.fetch(:member_token)
      end
    end

  end
end
