# frozen_string_literal: true

module AFK
  # imports projects/tasks from Trello and formats them to output
  class Runner

    attr_accessor :output

    def initialize(output: STDOUT)
      @output = output
    end

    def call
      forest = AFK::Trello::Importer.new.()
      output.write(AFK::Formatter.new.(forest))
    end

  end
end
