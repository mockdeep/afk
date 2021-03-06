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
      expect(task_1.children).to be_empty
      expect(task_2.title).to eq 'one other task'
      expect(task_2.children).to be_empty
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
      expect(kitchen.children).to be_empty
      expect(bedroom.children).to be_empty
      expect(work_project.title).to eq 'Work'
      expect(work_project.children.count).to eq 1
      expect(work_project.children.first.title).to eq 'Desk'
      expect(random_project.title).to eq 'Random'
      expect(random_project.children).to be_empty
    end
  end

  it 'associates tasks with projects from project list' do
    project_list_name = 'All the Projects'
    today_list_name = 'Nested Task'
    AFK.configuration.trello[:project_list_name] = project_list_name
    AFK.configuration.trello[:today_list_name] = today_list_name
    VCR.use_cassette('Projects and Tasks') do
      forest = importer.()
      expect(forest.count).to eq 3
      home_project = forest.first
      expect(home_project.title).to eq 'Home'
      expect(home_project.children.count).to eq 2
      kitchen_project = home_project.children.first
      expect(kitchen_project.children.count).to eq 1
      expect(kitchen_project.children.first.title).to eq 'one kitchen task'
    end
  end

  it 'processes a single task card checklist as sub-tasks' do
    today_list_name = 'Checklist Tasks'
    AFK.configuration.trello[:today_list_name] = today_list_name
    VCR.use_cassette(today_list_name) do
      forest = importer.()
      expect(forest.count).to eq 2
      home = forest.first
      laundry = home.children.first
      expect(laundry).to be_a(AFK::Task)
      children = laundry.children
      expect(children.count).to eq 4
      expect(children).to all(be_an(AFK::Task))
      expect(children.map(&:title)).to eq [
        'put colors in washer',
        'put lights in washer',
        'put colors away',
        'put lights away',
      ]
    end
  end

  it 'processes multiple task card checklists as separate lists' do
    today_list_name = 'Checklist Tasks'
    AFK.configuration.trello[:today_list_name] = today_list_name
    VCR.use_cassette(today_list_name) do
      forest = importer.()
      expect(forest.count).to eq 2
      _, evening = forest
      expect(evening.children.count).to eq 2
      rituals, list_stuff = evening.children
      expect(rituals.children.map(&:title)).to eq [
        'Brush teeth',
        'Put on sponge bob pajamas',
      ]
      expect(list_stuff.children.map(&:title)).to eq [
        'Clear inbox',
        'Print AFK list',
      ]
    end
  end
end
