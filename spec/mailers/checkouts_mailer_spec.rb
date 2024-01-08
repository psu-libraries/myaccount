# frozen_string_literal: true

require 'rails_helper'

describe CheckoutsMailer do
  describe '#export_checkouts' do
    subject(:email) { described_class.export_checkouts(username, checkouts) }

    let(:username) { 'test123' }
    let(:checkouts) {
 [{ title: 'Becoming', author: 'Obama, Michelle, 1964- author.', catkey: '24053587', call_number: 'E909.O24A3 2018' }] }
    let(:body) { email.body.raw_source }

    it "sends the email to the given user's email address" do
      expect(email.to).to eq ['test123@psu.edu']
    end

    it 'sends the email from the correct address' do
      expect(email.from).to eq ['noreply@psu.edu']
    end

    it 'sends the email with the correct subject' do
      expect(email.subject).to eq 'Current Checkouts'
    end

    it 'sets the correct reply-to address' do
      expect(email.reply_to).to be_nil
    end

    it 'contains checkouts data' do
      expect(body).to match('Catalog URL: https://catalog.libraries.psu.edu/catalog/24053587')
      expect(body).to match('Title: Becoming')
      expect(body).to match('Author: Obama, Michelle, 1964- author.')
      expect(body).to match('Call Number: E909.O24A3 2018')
    end
  end

  describe '#export_ill_checkouts' do
    subject(:email) { described_class.export_ill_checkouts(username, checkouts) }

    let(:username) { 'test123' }
    let(:checkouts) {
 [{ title: 'Snow country', author: 'Kawabata, Yasunari, 1899-1972.', date: '2016', identifier: '1234567890' }] }
    let(:body) { email.body.raw_source }

    it "sends the email to the given user's email address" do
      expect(email.to).to eq ['test123@psu.edu']
    end

    it 'sends the email from the correct address' do
      expect(email.from).to eq ['noreply@psu.edu']
    end

    it 'sends the email with the correct subject' do
      expect(email.subject).to eq 'Current ILLiad Checkouts'
    end

    it 'sets the correct reply-to address' do
      expect(email.reply_to).to be_nil
    end

    it 'contains checkouts data' do
      expect(body).to match('Date: 2016')
      expect(body).to match('Title: Snow country')
      expect(body).to match('Author: Kawabata, Yasunari, 1899-1972.')
      expect(body).to match('Identifier: 1234567890')
    end
  end
end
