# frozen_string_literal: true
module AFK
  # stores task information
  class Task

    attr_reader :children, :title

    def initialize(title)
      @title = title
      @children = AFK::NodeCollection.new
    end

    def add_child_task(title)
      @children.add_task(title)
    end

    def signifier
      AFK.configuration.task_signifier
    end

    def inspect
      "<Task> #{title.inspect}"
    end

  end
end
