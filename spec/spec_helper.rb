# frozen_string_literal: true
require_relative '../lib/afk'

require 'vcr'

RSpec.configuration.after { AFK.reset }

trello = AFK.configuration.trello
trello[:board_id] = 'ui1o0UsE'
trello[:developer_public_key] ||= ENV.fetch('TRELLO_DEVELOPER_PUBLIC_KEY')
trello[:member_token] ||= ENV.fetch('TRELLO_MEMBER_TOKEN')

VCR.configure do |config|
  config.cassette_library_dir = 'tmp/vcr_cassettes'
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.filter_run_when_matching :focus
end
