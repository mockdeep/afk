# frozen_string_literal: true
require_relative '../lib/afk'

require 'vcr'

RSpec.configuration.after { AFK.reset }

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
end
