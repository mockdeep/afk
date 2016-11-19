# frozen_string_literal: true
require 'trello'

module AFK
  module Trello
    # imports projects/tasks from Trello
    class Importer

      def call
        AFK::NodeCollection.new.tap do |collection|
          today_list.cards.each do |card|
            collection.add_task(card.name)
            add_checklists(collection, card)
          end
          project_list.cards.each { |card| collection.add_project(card.name) }
        end
      end

    private

      def add_checklists(collection, card)
        card.checklists.each do |checklist|
          checklist.items.each do |item|
            collection.add_task("#{card.name}: #{item.name}")
          end
        end
      end

      def project_list
        @project_list ||= find_list(project_list_name) || null_list
      end

      def project_list_name
        AFK.configuration.trello.fetch(:project_list_name)
      end

      def today_list
        lists.detect { |list| list.name == today_list_name }
      end

      def today_list_name
        AFK.configuration.trello.fetch(:today_list_name)
      end

      def lists
        @lists ||= board.lists
      end

      def board
        @board ||= ::Trello::Board.find(board_id)
      end

      def board_id
        AFK.configuration.trello.fetch(:board_id)
      end

      def null_list
        AFK::Trello::NullList.new
      end

      def find_list(list_name)
        lists.detect { |list| list.name == list_name }
      end

    end
  end
end
