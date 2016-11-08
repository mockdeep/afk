# frozen_string_literal: true
module AFK
  # stores project information
  class Project

    attr_reader :title

    def initialize(title)
      @title = title
      @children = []
    end

    def add_child(node)
      @children << node
    end

    def children
      @children.any? ? @children : [Task.new('')]
    end

    def signifier
      '▶'
    end

  end
end
