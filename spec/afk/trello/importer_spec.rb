# frozen_string_literal: true
RSpec.describe AFK::Trello::Importer do
  let(:importer) { described_class.new }

  it 'imports simple unadorned tasks' do
    list_name = 'Basic Tasks'
    AFK.configuration.trello[:today_list_name] = list_name
    VCR.use_cassette(list_name) do
      forest = importer.()
      expect(forest.length).to eq 2
      task_1, task_2 = forest
      expect(task_1.title).to eq 'one simple task'
      expect(task_1.children).to eq []
      expect(task_2.title).to eq 'one other task'
      expect(task_2.children).to eq []
    end
  end

  it 'imports a task with a project from the title' do
    list_name = 'Tasks With Project'
    AFK.configuration.trello[:today_list_name] = list_name
    VCR.use_cassette(list_name) do
      forest = importer.()
      expect(forest.size).to eq 1
      project = forest.first
      expect(project.title).to eq 'Home'
      expect(project.children.length).to eq 2
      task_1, task_2 = project.children
      expect(task_1.title).to eq 'first task'
      expect(task_2.title).to eq 'last task'
    end
  end

  it 'imports a project nested within another project' do
    list_name = 'Nested Task'
    AFK.configuration.trello[:today_list_name] = list_name
    VCR.use_cassette(list_name) do
      forest = importer.()
      expect(forest.size).to eq 1
      project = forest.first
      expect(project.title).to eq 'Home'
      expect(project.children.length).to eq 1
      nested_project = project.children.first
      expect(nested_project.title).to eq 'Kitchen'
      expect(nested_project.children.length).to eq 1
      expect(nested_project.children.first.title).to eq 'one kitchen task'
    end
  end
end
