# frozen_string_literal: true

RSpec.describe AFK::Configuration do
  let(:configuration) { described_class.new }

  describe '#project_signifier' do
    it 'defaults to ▶' do
      expect(configuration.project_signifier).to eq '▶'
    end

    it 'can be configured' do
      configuration.project_signifier = '⍨'
      expect(configuration.project_signifier).to eq '⍨'
    end
  end

  describe '#task_signifier' do
    it 'defaults to ▢' do
      expect(configuration.task_signifier).to eq '▢'
    end

    it 'can be configured' do
      configuration.task_signifier = '⍨'
      expect(configuration.task_signifier).to eq '⍨'
    end
  end

  it 'does not allow changing non-configurations' do
    expect do
      configuration.pizza_signifier = '⍨'
    end.to raise_error(NoMethodError)
  end
end
