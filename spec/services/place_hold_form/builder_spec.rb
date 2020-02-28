# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHoldForm::Builder do
  subject(:builder) { described_class.new(catkey: catkey, user_token: user_token, client: client) }
  let(:catkey) { '1' }
  let(:user_token) { '2asf' }
  let(:client) { instance_double(SymphonyClient) }
  let(:bib_info) { build(:bib_with_holdables) }
  let(:call_list) { [build(:call), build(:call), build(:call), build(:call), build(:call)] }
  let(:holdable_locations) { HOLDABLE_LOCATIONS }

  before do
    allow(Bib).to receive(:new).and_return(bib_info)
    allow(builder).to receive(:parsed_symphony_response).with(:get_bib_info, catkey, user_token)
    allow(builder).to receive(:parsed_symphony_response).with(:get_all_locations)
    allow(builder).to receive(:find_holdable_locations).and_return(holdable_locations)
  end

  describe '#generate' do
    context 'when there are volumetric calls to present to the user' do
      it 'will return a list of holdable items naturally sorted on volumetric' do
        form_params = builder.generate

        expected_order = [['bklet'], ['v', 1.0], ['v', 2.0], ['v', 3.0], ['v', 4.0], ['v', 5.0], ['v', 6.0], ['v', 7.0]]
        volumetrics_in_order = form_params[:volumetric_calls].map { |h| h.record['naturalized_volumetric'] }
        expect(volumetrics_in_order).to eq expected_order
      end
    end



  end

# it 'will generate holdables when supplied with a body that has a callList' do
#   expect(bib_with_holdables.holdables.count).to be 8
# end
#
#
#   describe '#holdables' do
#
#     context 'with an item list that does not contain any volumetrics' do
#       it 'will not generate any new holds' do
#         allow(bib_without_holdables).to receive(:volumetric?).and_return(false)
#
#         expect(bib_without_holdables.holdables).to be nil
#       end
#     end
#
#     context 'with an item list without any holdable items' do
#       it 'will not generate any new holds' do
#         expect(bib_without_holdables.holdables).to be nil
#       end
#     end
#
#     context 'with an item list with only one potential holdable item' do
#       it 'will not generate any new holds' do
#         allow(bib_without_holdables).to receive(:potential_holdables).and_return([instance_double('Hold')])
#
#         expect(bib_without_holdables.holdables).to be nil
#       end
#     end
#
#     context 'with an item list where there is only one holdable item' do
#       it 'will not generate any new holds' do
#         allow(bib_without_holdables).to receive(:filter_holdables).and_return([instance_double('Hold')])
#
#         expect(bib_without_holdables.holdables).to be nil
#       end
#     end
#   end
end