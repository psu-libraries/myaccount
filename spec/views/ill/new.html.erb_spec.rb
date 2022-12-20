# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ill/new.html.erb', type: :view do
  let(:form_params) { {
    catkey: '1',
    title: 'How to Eat More Pizza',
    author: 'Samantha Smith'
  } }

  before do
    assign(:place_loan_form_params, form_params)

    render
  end

  it 'renders title' do
    expect(rendered).to have_content('Title: How to Eat More Pizza')
  end

  it 'renders author' do
    expect(rendered).to have_content('Author: Samantha Smith')
  end

  xit 'renders not needed after date'
  xit 'renders alternate edition checkbox'
  xit 'renders ebook checkbox'
  xit 'renders notes checkbox'

  it 'provides a way to Cancel and go back to the catalog' do
    expect(rendered).to include 'href="https://catalog.libraries.psu.edu/catalog/1">Cancel'
  end
end
