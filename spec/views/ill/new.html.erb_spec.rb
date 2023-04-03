# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ill/new.html.erb' do
  let(:form_params) { {
    catkey: '1',
    title: 'How to Eat More Pizza',
    author: 'Samantha Smith'
  } }
  let(:page) { Capybara.string(rendered) }

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

  it 'renders not needed after date' do
    expect(rendered).to include DateTime.now.+(45.days).strftime('%Y-%m-%d')
  end

  it 'renders alternate edition checkbox' do
    input = page.find('input#accept_alternate_edition')

    expect(input['type']).to eq 'checkbox'
  end

  it 'renders ebook checkbox' do
    input = page.find('input#accept_ebook')

    expect(input['type']).to eq 'checkbox'
  end

  xit 'renders notes checkbox'

  it 'provides a way to Cancel and go back to the catalog' do
    expect(rendered).to include 'href="https://catalog.libraries.psu.edu/catalog/1">Cancel'
  end

  it 'provides a link to the new non-ill hold form for this item' do
    expect(rendered).to include "href=#{new_hold_path}?catkey=#{form_params[:catkey]}>Request a local copy"
  end
end
