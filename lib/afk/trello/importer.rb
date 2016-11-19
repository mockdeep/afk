# frozen_string_literal: true
require 'trello'

module AFK
  module Trello
    # imports projects/tasks from Trello
    class Importer

      def call
        project_tree = AFK::NodeCollection.new
        top_tasks = []
        today_list.cards.each do |card|
          if card.name.include?(':')
            project_tree.add_task(card.name)
          else
            top_tasks << AFK::Task.new(card.name)
          end
        end
        top_tasks + project_tree.nodes
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

    end
  end
end
