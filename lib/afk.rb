# frozen_string_literal: true

require_relative 'afk/configuration'
require_relative 'afk/formatter'
require_relative 'afk/node_collection'
require_relative 'afk/project'
require_relative 'afk/runner'
require_relative 'afk/task'
require_relative 'afk/version'
require_relative 'afk/trello/importer'
require_relative 'afk/trello/null_list'

# namespace for all AFK code
module AFK
  def self.configuration
    @configuration ||= AFK::Configuration.new
  end

  def self.reset
    @configuration = nil
  end
end
