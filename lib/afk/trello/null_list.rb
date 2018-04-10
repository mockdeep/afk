# frozen_string_literal: true

module AFK
  module Trello
    # stand in list when not found on Trello
    class NullList

      def cards
        []
      end

    end
  end
end
