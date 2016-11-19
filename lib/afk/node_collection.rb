# frozen_string_literal: true
module AFK
  # groups project/task node trees
  class NodeCollection

    attr_reader :indexed_nodes, :nodes

    include Enumerable

    def initialize
      @nodes = []
      @indexed_nodes = {}
    end

    def add_project(project_title)
      title, rest = project_title.split(':', 2).map(&:strip)
      project = fetch_project(title)
      project.add_child_project(rest) if rest
    end

    def add_task(task_title)
      project_title, rest = task_title.split(':', 2).map(&:strip)
      if rest
        project = fetch_project(project_title)
        project.add_child_task(rest)
      else
        add_task_node(task_title)
      end
    end

    def each(&block)
      nodes.each(&block)
    end

    def to_ary
      nodes
    end

    def inspect
      nodes
    end

    def empty?
      !any?
    end

  private

    def fetch_project(title)
      indexed_nodes[title] ||= begin
        AFK::Project.new(title).tap { |project| nodes << project }
      end
    end

    def add_task_node(title)
      indexed_nodes[title] ||= begin
        AFK::Task.new(title).tap { |task| nodes << task }
      end
    end

  end
end
