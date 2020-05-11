# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutsHelper do
  describe '#render_checkout_due_date' do
    let(:due_dates) { ['Recalled', 'November 10, 2019 10:30pm', 'November 14, 2019'] }
    let(:content) { helper.render_checkout_due_date(due_dates) }

    it 'renders the right html' do
      expect(content).to have_css('span', text: 'RecalledNovember 10, 2019 10:30pmNovember 14, 2019')
    end
  end

  describe '#render_renew_button' do
    it 'renders the right html' do
      renew_button = '<input type="submit" name="commit" value="Renew" class="btn btn-primary" '\
                     'data-disable-with="Please wait..." />'
      expect(helper.render_renew_button).to include(renew_button)
    end
  end
end
