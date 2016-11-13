# frozen_string_literal: true
module AFK
  # Configuration class
  class Configuration

    attr_accessor :project_signifier, :task_signifier

    def initialize
      self.project_signifier = '▶'
      self.task_signifier = '▢'
    end

  end
end
