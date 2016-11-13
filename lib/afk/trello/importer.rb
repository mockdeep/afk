# frozen_string_literal: true
require 'trello'

module AFK
  module Trello
    # imports projects/tasks from Trello
    class Importer

      def call
        project_tree = {}
        top_tasks = []
        today_list.cards.each do |card|
          if card.name.include?(':')
            parse_project(card.name, project_tree)
          else
            top_tasks << AFK::Task.new(card.name)
          end
        end
        top_tasks + collect_projects(project_tree)
      end

    private

      def today_list
        board.lists.detect { |list| list.name == today_list_name }
      end

      def today_list_name
        AFK.configuration.trello.fetch(:today_list_name)
      end

      def board
        @board ||= ::Trello::Board.find(board_id)
      end

      def board_id
        AFK.configuration.trello.fetch(:board_id)
      end

      def parse_project(title, project_tree)
        return AFK::Task.new(title) unless title.include?(':')

        project_title, title = title.split(':', 2).map(&:strip)
        project_node = fetch_project_node(project_tree, project_title)
        project = project_node.fetch(:project)
        child = parse_project(title, project_node.fetch(:sub_projects))
        project.add_child(child)
        project
      end

      def fetch_project_node(project_tree, project_title)
        project_tree[project_title] ||= {
          project: AFK::Project.new(project_title),
          sub_projects: {},
        }

        project_tree.fetch(project_title)
      end

      def collect_projects(project_tree)
        project_tree.values.map { |project_node| project_node.fetch(:project) }
      end

    end
  end
end
