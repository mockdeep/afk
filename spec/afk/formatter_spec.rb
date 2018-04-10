# frozen_string_literal: true

RSpec.describe AFK::Formatter do
  let(:formatter) { described_class.new }
  let(:collection) { AFK::NodeCollection.new }

  it 'formats individual task nodes' do
    collection.add_task('just a task')
    expect(formatter.(collection)).to eq('▢ just a task')
    collection.add_task('another task')
    expect(formatter.(collection)).to eq(
      <<~LISTING.strip
        ▢ just a task

        ▢ another task
      LISTING
    )
  end

  it 'formats empty project nodes' do
    collection.add_project('top project')

    expect(formatter.(collection)).to eq(
      <<~LISTING.strip
        ▶ top project
          ▢
      LISTING
    )
    collection.add_project('another project')
    expect(formatter.(collection)).to eq(
      <<~LISTING.strip
        ▶ top project
          ▢

        ▶ another project
          ▢
      LISTING
    )
  end

  it 'formats project nodes with child tasks' do
    collection.add_task('top project: top task!')
    expect(formatter.(collection)).to eq(
      <<~LISTING.strip
        ▶ top project
          ▢ top task!
      LISTING
    )
    collection.add_task('another project: second task')
    expect(formatter.(collection)).to eq(
      <<~LISTING.strip
        ▶ top project
          ▢ top task!

        ▶ another project
          ▢ second task
      LISTING
    )
  end

  it 'formats nested projects' do
    collection.add_task('top project: top task!')
    collection.add_task('top project: nested project: nested task')

    expect(formatter.(collection)).to eq(
      <<~LISTING.strip
        ▶ top project
          ▢ top task!
          ▶ nested project
            ▢ nested task
      LISTING
    )
  end
end
