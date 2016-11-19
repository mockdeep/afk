# frozen_string_literal: true
RSpec.describe AFK::NodeCollection do
  let(:node_collection) { described_class.new }

  describe '#add_project' do
    it 'adds projects to the tree' do
      expect do
        node_collection.add_project('Eat: At: Joes')
        node_collection.add_project('Eat: At: Marys')
      end.to change(node_collection, :count).from(0).to(1)
      project = node_collection.first
      expect(project).to be_a(AFK::Project)
      expect(project.title).to eq 'Eat'
      expect(project.children.count).to eq 1
      nested_project = project.children.first
      expect(nested_project).to be_a(AFK::Project)
      expect(nested_project.title).to eq 'At'
      expect(nested_project.children.count).to eq 2
      joes, marys = nested_project.children
      expect(joes).to be_a(AFK::Project)
      expect(joes.title).to eq 'Joes'
      expect(joes.children).to be_empty
      expect(marys).to be_a(AFK::Project)
      expect(marys.title).to eq 'Marys'
      expect(marys.children).to be_empty
    end
  end

  describe '#add_task' do
    it 'adds nested tasks to the tree' do
      expect do
        node_collection.add_task('Eat: At: Joes')
        node_collection.add_task('Eat: At: Marys')
      end.to change(node_collection, :count).from(0).to(1)
      project = node_collection.first
      expect(project).to be_a(AFK::Project)
      expect(project.title).to eq 'Eat'
      expect(project.children.count).to eq 1
      nested_project = project.children.first
      expect(nested_project).to be_a(AFK::Project)
      expect(nested_project.title).to eq 'At'
      expect(nested_project.children.count).to eq 2
      joes, marys = nested_project.children
      expect(joes).to be_a(AFK::Task)
      expect(joes.title).to eq 'Joes'
      expect(joes.children).to be_empty
      expect(marys).to be_a(AFK::Task)
      expect(marys.title).to eq 'Marys'
      expect(marys.children).to be_empty
    end
  end

  describe '#empty?' do
    it 'returns true when there is nothing in the collection' do
      expect(node_collection).to be_empty
    end

    it 'returns false when there are projects in the collection' do
      node_collection.add_project('Wat')
      expect(node_collection).not_to be_empty
    end

    it 'returns false when there are tasks in the collection' do
      node_collection.add_task('Wat')
      expect(node_collection).not_to be_empty
    end
  end
end
