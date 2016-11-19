# frozen_string_literal: true
require_relative '../lib/afk'

require 'vcr'

AFK::Configuration.loaded_config[:trello] = {
  board_id: 'ui1o0UsE',
  project_list_name: 'not a project',
  developer_public_key: ENV.fetch('TRELLO_DEVELOPER_PUBLIC_KEY'),
  member_token: ENV.fetch('TRELLO_MEMBER_TOKEN'),
}

RSpec.configure do |config|
  config.after { AFK.reset }
  config.filter_run_when_matching :focus
end

VCR.configure do |config|
  config.cassette_library_dir = 'tmp/vcr_cassettes'
  config.hook_into :webmock
end
