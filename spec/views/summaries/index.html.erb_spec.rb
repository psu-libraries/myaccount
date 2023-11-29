# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'summaries/index' do
  let(:fines) { [build(:fine)] }
  let(:patron_standing) { {} }
  let(:eligible_for_wage_garnishment) { false }
  let(:illiad_response) { instance_double(IlliadResponse) }
  let(:patron) do
    instance_double(
      Patron,
      display_name: 'Test First Last',
      checkouts: [],
      holds: [],
      fines:,
      eligible_for_wage_garnishment?: eligible_for_wage_garnishment,
      **patron_standing
    )
  end
  let(:patron_checkout) { instance_double(Checkout, recalled?: false, overdue?: false) }

  before do
    controller.singleton_class.class_eval do
      protected

        def patron; end

        def current_user?; end

        helper_method :patron, :current_user?
    end

    assign(:illiad_response, illiad_response)

    without_partial_double_verification {
      allow(view).to receive(:patron).and_return(patron)
      allow(view).to receive(:current_user?).and_return(true)
      allow(illiad_response).to receive(:illiad_checkouts).and_return([])
      allow(illiad_response).to receive(:illiad_holds).and_return([])
      allow(illiad_response).to receive(:ill_recalled).and_return(0)
      allow(illiad_response).to receive(:ill_overdue).and_return(0)
      allow(illiad_response).to receive(:ill_ready_for_pickup).and_return(0)
    }
  end

  context 'when the patron standing is OK' do
    let(:patron_standing) { { standing_human: '' } }

    it 'renders without alerts' do
      render

      expect(rendered).not_to have_css('h3', text: 'Alerts:')
    end
  end

  context 'when the patron standing is not OK' do
    let(:patron_standing) { { standing_human: 'The user is BARRED.' } }

    it 'renders with alerts' do
      render

      expect(rendered).to have_css('h3', text: 'Alerts:')
    end

    context 'when the user is eligible for wage garnishment' do
      let(:eligible_for_wage_garnishment) { true }

      it 'shows a link to the accept lending policy page' do
        render

        expect(rendered).to have_link('accept the University Libraries lending policy',
                                      href: lending_policy_accept_path)
      end
    end

    context 'when the user is not eligible for wage garnishment' do
      it 'does not show a link to the accept lending policy page' do
        render

        expect(rendered).not_to have_link('accept the University Libraries lending policy')
      end
    end
  end

  context 'when the patron does not have any symphony checkouts, holds or bills' do
    let(:patron_standing) { { standing_human: '' } }
    let(:fines) { [] }

    before do
      allow(DashboardItemComponent).to receive(:new).and_return({ plain: 'OK' })
    end

    context 'when the patron does not have any ILLiad holds or checkouts' do
      it 'renders text for no materials and no bills and link to ILLiad' do
        render

        expect(rendered).to
        include('<p>See and manage your <a href="https://illiad.illiad/illiad">Interlibrary loans</a></p>')
        expect(rendered).to include('You do not have any outstanding materials or bills.')
      end
    end

    context 'when the patron does have an illiad hold or checkout' do
      before do
        allow(illiad_response).to receive(:illiad_holds).and_return [Object.new]
      end

      it 'does not render text for no materials and no bills nor the link to ILLiad' do
        render

        expect(rendered).not_to
        include('<p>See and manage your <a href="https://illiad.illiad/illiad">Interlibrary loans</a></p>')
        expect(rendered).not_to include('You do not have any outstanding materials or bills.')
      end
    end
  end

  context 'when the patron has symphony checkouts, holds or bills' do
    let(:patron_standing) { { standing_human: '' } }
    let(:fines) { [] }

    before do
      allow(patron).to receive(:checkouts).and_return([patron_checkout])
      allow(DashboardItemComponent).to receive(:new).and_return({ plain: 'OK' })
    end

    context 'when the patron does not have any ILLiad holds or checkouts' do
      it 'renders text for no materials and no bills and link to ILLiad' do
        render

        expect(rendered).to
        include('<p>See and manage your <a href="https://illiad.illiad/illiad">Interlibrary loans</a></p>')
        expect(rendered).not_to include('You do not have any outstanding materials or bills.')
      end
    end

    context 'when the patron does have an illiad hold or checkout' do
      before do
        allow(illiad_response).to receive(:illiad_holds).and_return [Object.new]
      end

      it 'does not render text for no materials and no bills nor the link to ILLiad' do
        render

        expect(rendered).not_to
        include('<p>See and manage your <a href="https://illiad.illiad/illiad">Interlibrary loans</a></p>')
        expect(rendered).not_to include('You do not have any outstanding materials or bills.')
      end
    end
  end
end
