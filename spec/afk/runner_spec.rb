# frozen_string_literal: true
RSpec.describe AFK::Runner do
  let(:output) { StringIO.new }
  let(:runner) { described_class.new(output: output) }

  it 'runs the output of the importer through the formatter and outputs it' do
    list_name = 'Nested Projects'
    AFK.configuration.trello[:today_list_name] = list_name
    VCR.use_cassette(list_name) do
      runner.()
    end
    expect(output.string).to eq(
      <<~LISTING.strip
        ▶ Home
          ▶ Kitchen
            ▢ one kitchen task
      LISTING
    )
  end
end
