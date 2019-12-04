# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'summaries/index', type: :view do
  let(:patron_standing) { {} }
  let(:patron) do
    instance_double(
      Patron,
      display_name: 'Test First Last',
      checkouts: [],
      holds: [],
      **patron_standing
    )
  end

  before do
    controller.singleton_class.class_eval do
      protected

        def patron; end

        def current_user?; end

        helper_method :patron, :current_user?
    end

    allow(view).to receive(:patron).and_return(patron)
    allow(view).to receive(:current_user?).and_return(true)
  end

  context 'when the patron standing is OK' do
    let(:patron_standing) { { standing: 'OK', standing_alert?: false } }

    it 'renders without alerts' do
      render

      expect(rendered).not_to have_css('h3', text: 'Alerts:')
    end
  end

  context 'when the patron standing is not OK' do
    let(:patron_standing) { { standing: 'BARRED', standing_alert?: true } }

    it 'renders with alerts' do
      render

      expect(rendered).to have_css('h3', text: 'Alerts:')
    end
  end
end
