# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHoldForm::Builder do
  subject(:builder) { described_class.new(catkey: catkey, user_token: user_token, client: client) }

  let(:catkey) { '1' }
  let(:user_token) { '2asf' }
  let(:client) { instance_double(SymphonyClient) }
  let(:bib_info) { build(:bib_with_holdables) }
  let(:holdable_locations) { HOLDABLE_LOCATIONS_RAW_JSON }
  let(:form_params) { builder.generate }
  let(:get_bib_info_response) { instance_double(HTTP::Response) }
  let(:get_all_locations_response) { instance_double(HTTP::Response) }

  before do
    allow(Bib).to receive(:new).and_return(bib_info)
    allow(client).to receive(:get_bib_info).with(catkey, user_token).and_return(get_bib_info_response)
    allow(get_bib_info_response).to receive(:body).and_return ''.to_json

    allow(client).to receive(:get_all_locations).and_return(get_all_locations_response)
    allow(get_all_locations_response).to receive(:body).and_return holdable_locations.to_json
  end

  describe '#generate' do
    it 'will pass along catkey' do
      expect(form_params[:catkey]).to eq '1'
    end

    it 'will pass along title' do
      expect(form_params[:title]).to eq 'Hill Street blues. The complete series'
    end

    it 'will pass along author' do
      expect(form_params[:author]).to eq 'Hill Street blues (Television program)'
    end

    context 'when there are volumetric calls to present to the user' do
      it 'will generate holdables when supplied with a body that has a callList' do
        expect(form_params[:volumetric_calls].count).to be 8
      end

      it 'will return a list of holdable items naturally sorted on volumetric' do
        expected_order = [['bklet'], ['v', 1.0], ['v', 2.0], ['v', 3.0], ['v', 4.0], ['v', 5.0], ['v', 6.0], ['v', 7.0]]
        volumetrics_in_order = form_params[:volumetric_calls].map { |h| h.record['naturalized_volumetric'] }
        expect(volumetrics_in_order).to eq expected_order
      end

      context 'when one item is not holdable' do
        before do
          bib_info.record['fields']['callList'].first['fields']['itemList']
            .first['fields']['currentLocation']['key'] = 'ARCHIVE-MP'
        end

        it 'will not pass along that item\'s parent call to the user' do
          expect(form_params[:volumetric_calls].count).to be 7
        end
      end
    end

    context 'when there aren\'t enough volumetric calls to present to require user select' do
      let(:bib_info) { build(:bib_without_holdables) }

      it 'will not generate any volumetric holdables' do
        expect(form_params[:volumetric_calls]).to be_empty
      end

      it 'will pass along a random barcode' do
        # The list of possible_barcodes was generated from the following block processing. Because @call_list isn't a
        # public instance variable it is not something that client code can find.
        # @call_list.collect {|c| c.items.collect { |i| i.barcode }}.flatten
        possible_barcodes = ['000080793182', '000081297085', '000081321605', '000081287932', '000081402335']
        expect(possible_barcodes).to include form_params[:barcode]
      end
    end
  end
end
