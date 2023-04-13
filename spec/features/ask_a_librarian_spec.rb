# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ask a librarian' do
  let(:mock_user) { 'patron2' }

  before do
    stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
      .with(headers: {
              'Apikey' => '1234',
              'Connection' => 'close',
              'Content-Type' => 'application/json',
              'Host' => 'illiad.illiad',
              'User-Agent' => 'http.rb/4.4.1'
            })
      .to_return(status: 200, body: '[]', headers: {})
    login_as username: 'PATRON2', patron_key: mock_user
  end

  describe 'side tab widget', js: true do
    it 'shows up on the homepage' do
      visit summaries_path
      expect(page).to have_css('button[class^="libchat"]')
    end
  end
end
