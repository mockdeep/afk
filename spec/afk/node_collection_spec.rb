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
      expect(project.title).to eq 'Eat'
      expect(project.children.count).to eq 1
      nested_project = project.children.first
      expect(nested_project.title).to eq 'At'
      expect(nested_project.children.count).to eq 2
      joes, marys = nested_project.children
      expect(joes.title).to eq 'Joes'
      expect(joes.children.count).to eq 1
      expect(marys.title).to eq 'Marys'
      expect(marys.children.count).to eq 1
    end
  end
end
