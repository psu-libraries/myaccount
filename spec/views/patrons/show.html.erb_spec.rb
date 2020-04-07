# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'patrons/show', type: :view do
  before do
    client = SymphonyClient.new
    # Patron below is mocked, see patron.json
    assign(:patron, Patron.new(client.patron_info(patron_key: 'patron1', session_token: 'fasfasf', item_details: {})))
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(/LASTNAME/)
    expect(rendered).to match(/FIRSTNAME/)
    expect(rendered).to match(/H/)
    expect(rendered).to match(/ALTOONA/)
    expect(rendered).to match(/zzz123@psu.edu/)
    expect(rendered).to match(/123 Fake Street/)
    expect(rendered).to match(/Jersey Shore, KY/)
    expect(rendered).to match(/00000/)
  end
end
