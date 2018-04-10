# frozen_string_literal: true

require 'trello'

module AFK
  module Trello
    # imports projects/tasks from Trello
    class Importer

      def call
        AFK::NodeCollection.new.tap do |collection|
          puts 'adding today list'
          today_list.cards.each do |card|
            print '.'
            collection.add_task(card.name)
            add_checklists(collection, card)
          end
          puts
          puts 'adding project list'
          project_list.cards.each do |card|
            print '.'
            collection.add_project(card.name)
          end
        end
      end

    private

      def add_checklists(collection, card)
        card.checklists.each do |checklist|
          checklist_insert = checklist.name unless checklist.name == 'Checklist'
          checklist.items.each do |item|
            task_pieces = [card.name, checklist_insert, item.name].compact
            collection.add_task(task_pieces.join(': '))
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
