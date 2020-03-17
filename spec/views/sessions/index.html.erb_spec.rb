# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sessions/index', type: :view do
  it 'renders a login link' do
    render

    expect(rendered).to have_link('Log in', href: Settings.symws.webaccess_url + @request.base_url)
  end
end
