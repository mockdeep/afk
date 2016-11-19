# frozen_string_literal: true
module AFK
  # stores project information
  class Project

    attr_reader :title

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

    def children
      @children.any? ? @children : [AFK::Task.new('')]
    end

    def signifier
      AFK.configuration.project_signifier
    end

    def inspect
      "<Project> #{title.inspect} (#{children.inspect})"
    end

  end
end
