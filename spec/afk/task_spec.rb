# frozen_string_literal: true
RSpec.describe AFK::Task do
  describe '#title' do
    it 'returns the title of the task' do
      task = described_class.new('I am a task!')
      expect(task.title).to eq 'I am a task!'
      task = described_class.new('I am a task too')
      expect(task.title).to eq 'I am a task too'
    end
  end

  describe '#children' do
    it 'returns an empty array' do
      expect(described_class.new('').children).to eq []
    end
  end

  describe '#signifier' do
    it 'returns ▢ by default' do
      expect(described_class.new('foo').signifier).to eq '▢'
    end

    it 'returns a configured signifier' do
      AFK.configuration.task_signifier = '☣'
      expect(described_class.new('foo').signifier).to eq '☣'
    end
  end
end
