# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PatronHelper, type: :helper do
  describe '#render_us_states_dropdown' do
    context 'when patron does not have a state to be found' do
      it 'renders an options set with the default selected and disabled value of "Select a state"' do
        results = helper.render_us_states_dropdown(selected: nil)

        expect(results).to include('<option selected="selected" disabled="disabled" value="">Select a state</option>')
      end
    end

    context 'when patron has a state in their address' do
      it 'renders an options set with the default selected value of the passed in state acronym' do
        results = helper.render_us_states_dropdown(selected: 'PA')

        expect(results).not_to include('<option selected="selected" disabled="disabled" value="">Select a state'\
                                       '</option>')
        expect(results).to include('<option selected="selected" value="PA">Pennsylvania</option>')
      end
    end
  end
end
