# frozen_string_literal: true
RSpec.describe AFK::Formatter do
  let(:formatter) { described_class.new }

  it 'formats individual task nodes' do
    task_1 = AFK::Task.new('just a task')
    expect(formatter.([task_1])).to eq('▢ just a task')
    task_2 = AFK::Task.new('another task')
    expect(formatter.([task_1, task_2])).to eq(
      <<~LISTING.strip
        ▢ just a task

        ▢ another task
      LISTING
    )
  end

  it 'formats empty project nodes' do
    project_1 = AFK::Project.new('top project')
    expect(formatter.([project_1])).to eq(
      <<~LISTING.strip
        ▶ top project
          ▢
      LISTING
    )
    project_2 = AFK::Project.new('another project')
    expect(formatter.([project_1, project_2])).to eq(
      <<~LISTING.strip
        ▶ top project
          ▢

        ▶ another project
          ▢
      LISTING
    )
  end

  it 'formats project nodes with child tasks' do
    project_1 = AFK::Project.new('top project')
    task_1 = AFK::Task.new('top task!')
    project_1.add_child(task_1)
    expect(formatter.([project_1])).to eq(
      <<~LISTING.strip
        ▶ top project
          ▢ top task!
      LISTING
    )
    project_2 = AFK::Project.new('another project')
    task_2 = AFK::Task.new('second task')
    project_2.add_child(task_2)
    expect(formatter.([project_1, project_2])).to eq(
      <<~LISTING.strip
        ▶ top project
          ▢ top task!

        ▶ another project
          ▢ second task
      LISTING
    )
  end

  it 'formats nested projects' do
    project_1 = AFK::Project.new('top project')
    task_1 = AFK::Task.new('top task!')
    project_1.add_child(task_1)
    project_2 = AFK::Project.new('nested project')
    task_2 = AFK::Task.new('nested task')
    project_2.add_child(task_2)
    project_1.add_child(project_2)

    expect(formatter.([project_1])).to eq(
      <<~LISTING.strip
        ▶ top project
          ▢ top task!
          ▶ nested project
            ▢ nested task
      LISTING
    )
  end
end
