# frozen_string_literal: true
require 'spec_helper'

describe AFK do
  describe '.configuration' do
    it 'returns a configuration instance' do
      expect(described_class.configuration.project_signifier).to eq '▶'
    end

    it 'returns the same configuration instance every time' do
      once = described_class.configuration
      twice = described_class.configuration
      expect(once).to eq twice
    end

    it 'allows changing configuration' do
      described_class.configuration.project_signifier = '⍨'
      expect(described_class.configuration.project_signifier).to eq '⍨'
    end

    it 'does not allow changing non-configurations' do
      expect do
        described_class.configuration.pizza_signifier = '⍨'
      end.to raise_error(NoMethodError)
    end
  end

  describe '.reset' do
    it 'resets the configuration' do
      described_class.configuration.project_signifier = '⍨'
      described_class.reset
      expect(described_class.configuration.project_signifier).to eq '▶'
    end
  end
end
