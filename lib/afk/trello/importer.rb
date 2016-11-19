# frozen_string_literal: true
require 'trello'

module AFK
  module Trello
    # imports projects/tasks from Trello
    class Importer

      def call
        AFK::NodeCollection.new.tap do |collection|
          today_list.cards.each { |card| collection.add_task(card.name) }
        end
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
