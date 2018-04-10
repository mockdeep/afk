# frozen_string_literal: true

RSpec.describe AFK::Trello::NullList do
  let(:list) { described_class.new }

  describe '#cards' do
    it 'returns an empty collection' do
      expect(list.cards).to be_empty
    end
  end
end
