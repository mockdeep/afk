# frozen_string_literal: true
module AFK
  # stores task information
  class Task

    attr_reader :title

    def initialize(title)
      @title = title
    end

    def children
      []
    end

    def signifier
      AFK.configuration.task_signifier
    end

  end
end
