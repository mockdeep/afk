# frozen_string_literal: true
RSpec.describe AFK::Trello::Importer do
  let(:importer) { described_class.new }

  it 'imports simple unadorned tasks' do
    list_name = 'Basic Tasks'
    AFK.configuration.trello[:today_list_name] = list_name
    VCR.use_cassette(list_name) do
      forest = importer.()
      expect(forest.count).to eq 2
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
      expect(forest.count).to eq 1
      project = forest.first
      expect(project.title).to eq 'Home'
      expect(project.children.count).to eq 2
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
      expect(forest.count).to eq 1
      project = forest.first
      expect(project.title).to eq 'Home'
      expect(project.children.count).to eq 1
      nested_project = project.children.first
      expect(nested_project.title).to eq 'Kitchen'
      expect(nested_project.children.count).to eq 1
      expect(nested_project.children.first.title).to eq 'one kitchen task'
    end
  end

  it 'imports projects from a project list' do
    project_list_name = 'All the Projects'
    today_list_name = 'Empty List'
    AFK.configuration.trello[:project_list_name] = project_list_name
    AFK.configuration.trello[:today_list_name] = today_list_name
    VCR.use_cassette(project_list_name) do
      forest = importer.()
      expect(forest.count).to eq 3
      home_project, work_project, random_project = forest
      expect(home_project.title).to eq 'Home'
      expect(home_project.children.count).to eq 2
      kitchen, bedroom = home_project.children
      expect(kitchen.title).to eq 'Kitchen'
      expect(bedroom.title).to eq 'Bedroom'
      expect(kitchen.children.first.title).to eq ''
      expect(bedroom.children.first.title).to eq ''
      expect(work_project.title).to eq 'Work'
      expect(work_project.children.count).to eq 1
      expect(work_project.children.first.title).to eq 'Desk'
      expect(random_project.title).to eq 'Random'
      expect(random_project.children.count).to eq 1
      expect(random_project.children.first.title).to eq ''
    end
  end
end
