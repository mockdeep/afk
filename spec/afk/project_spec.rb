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

  describe '#add_child_project' do
    it 'adds a child project node' do
      project = described_class.new('Yay project')
      project.add_child_project('A: Child')
      expect(project.children.count).to eq 1
      child = project.children.first
      expect(child).to be_a(described_class)
      expect(child.title).to eq 'A'
      expect(child.children.count).to eq 1
      grand_child = child.children.first
      expect(grand_child).to be_a(described_class)
      expect(grand_child.title).to eq 'Child'
    end
  end

  describe '#add_child_task' do
    it 'adds a child task node' do
      project = described_class.new('Yay project')
      project.add_child_task('A: Child')
      expect(project.children.count).to eq 1
      child = project.children.first
      expect(child).to be_a(described_class)
      expect(child.title).to eq 'A'
      expect(child.children.count).to eq 1
      grand_child = child.children.first
      expect(grand_child).to be_a(AFK::Task)
      expect(grand_child.title).to eq 'Child'
    end
  end

  describe '#children' do
    it 'returns the child nodes of the project' do
      project = described_class.new('I am a project too!')
      project.add_child_task('I am the task')
      expect(project.children.map(&:title)).to eq ['I am the task']
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
