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
          *map_lines(node.children, indent: "#{indent}  "),
        ]
      end
    end

  end
end
