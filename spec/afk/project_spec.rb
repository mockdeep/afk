# frozen_string_literal: true
RSpec.describe AFK::Project do
  describe '#title' do
    it 'returns the title of the project' do
      project = described_class.new('I am a project!')
      expect(project.title).to eq 'I am a project!'
      project = described_class.new('I am a project too')
      expect(project.title).to eq 'I am a project too'
    end
  end

  describe '#add_child' do
    it 'adds a child node' do
      project = described_class.new('I am a project too!')
      project.add_child(AFK::Task.new('I am the task'))
      expect(project.children.map(&:title)).to eq ['I am the task']
    end
  end

  describe '#children' do
    it 'returns the child nodes of the project' do
      project = described_class.new('I am a project too!')
      project.add_child(AFK::Task.new('I am the task'))
      expect(project.children.map(&:title)).to eq ['I am the task']
    end

    it 'returns a blank task if there are none' do
      project = described_class.new('I am a project too!')
      expect(project.children.length).to eq 1
      first_child = project.children.first
      expect(first_child.title).to eq ''
      expect(first_child.signifier).to eq '▢'
    end
  end

  describe '#signifier' do
    it 'returns ▶ by default' do
      expect(described_class.new('foo').signifier).to eq '▶'
    end

    it 'returns a configured signifier' do
      AFK.configuration.project_signifier = '☃'
      expect(described_class.new('foo').signifier).to eq '☃'
    end
  end
end
