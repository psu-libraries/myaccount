# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'patrons/edit', type: :view do
  before do
    client = SymphonyClient.new
    # Patron below is mocked, see patron1.json
    assign(:patron, Patron.new(client.patron_info(patron_key: 'patron1', session_token: 'fasfasf', item_details: {})))
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(/\*First Name/)
    expect(rendered).to match(/\*Last Name/)
    expect(rendered).to match(/\*Email Address/)
    expect(rendered).to match(/\*Street/)
    expect(rendered).to match(/\*City/)
    expect(rendered).to match(/\*State/)
    expect(rendered).to match(/\*ZIP Code/)
  end
end
