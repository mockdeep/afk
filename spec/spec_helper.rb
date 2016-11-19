# frozen_string_literal: true
require_relative '../lib/afk'

require 'vcr'

RSpec.configuration.after { AFK.reset }

AFK.configuration.trello[:board_id] = 'ui1o0UsE'

VCR.configure do |config|
  config.cassette_library_dir = 'tmp/vcr_cassettes'
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.filter_run_when_matching :focus
end
