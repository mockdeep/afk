# frozen_string_literal: true

module AFK
  # formats task/project tree as a string
  class Formatter

    def call(nodes)
      map_top_nodes(nodes).join("\n\n")
    end

  private

    def map_top_nodes(nodes)
      nodes.map { |node| map_lines([node]).join("\n") }
    end

    def map_lines(nodes, indent: '')
      nodes.flat_map do |node|
        [
          "#{indent}#{node.signifier} #{node.title}".rstrip,
          *map_lines(children_for(node), indent: "#{indent}  "),
        ]
      end
    end

    def children_for(node)
      if node.is_a?(AFK::Project) && node.children.empty?
        [AFK::Task.new('')]
      else
        node.children
      end
    end

  end
end
