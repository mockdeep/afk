# frozen_string_literal: true
module AFK
  # stores project information
  class Project

    attr_reader :title, :children

    def initialize(title)
      @title = title
      @children = AFK::NodeCollection.new
    end

    def add_child_project(title)
      @children.add_project(title)
    end

    def add_child_task(title)
      @children.add_task(title)
    end

    def signifier
      AFK.configuration.project_signifier
    end

    def inspect
      "<Project> #{title.inspect} (#{children.inspect})"
    end

  end
end
