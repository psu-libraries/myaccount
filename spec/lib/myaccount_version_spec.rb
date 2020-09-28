# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyaccountVersion do
  subject(:myaccount_version) { described_class }

  after do
    Redis.current.flushall
  end

  describe 'self.version' do
    context 'when the GitHub API is operating as expected' do
      it 'returns the current version according to GitHub' do
        stub_request(:any, /api.github.com/).to_rack(FakeGithub)

        expect(myaccount_version.resolve_version).to eq 'v0.3.2'
      end
    end

    context 'when the GitHub API is operating an unexpected way' do
      it 'returns the string "not set"' do
        stub_request(:get, 'https://api.github.com/repos/psu-libraries/myaccount/releases')
          .to_return(status: 200, body: '{}', headers: {})
        expect(myaccount_version.resolve_version).to eq 'Version could not be determined'
      end
    end
  end
end
