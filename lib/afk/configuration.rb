# frozen_string_literal: true
module AFK
  # Configuration class
  class Configuration

    attr_accessor :project_signifier

    def initialize
      self.project_signifier = '▶'
    end

  end
end
