# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutsHelper do
  describe '#render_renew_button' do
    it 'renders the right html' do
      renew_button = '<input type="submit" name="commit" value="Renew" class="btn btn-primary" '\
                     'data-disable-with="Please wait..." />'
      expect(helper.render_renew_button).to include(renew_button)
    end
  end
end
