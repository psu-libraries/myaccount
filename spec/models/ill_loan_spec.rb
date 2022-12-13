# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IllLoan, type: :model do
  let(:ill_loan) { described_class.new(record) }
  let(:record) do
    {
      'TransactionNumber' => 123456, 'Username' => 'test123', 'RequestType' => 'Loan', 'LoanAuthor' => 'Author, Test',
      'LoanTitle' => 'The Book Title', 'LoanPublisher' => nil, 'LoanPlace' => nil, 'LoanDate' => nil,
      'LoanEdition' => nil, 'PhotoJournalTitle' => nil, 'PhotoJournalVolume' => nil, 'PhotoJournalIssue' => nil,
      'PhotoJournalMonth' => nil, 'PhotoJournalYear' => nil, 'PhotoJournalInclusivePages' => nil,
      'PhotoArticleAuthor' => nil, 'PhotoArticleTitle' => nil, 'CitedIn' => nil, 'CitedTitle' => nil,
      'CitedDate' => nil, 'CitedVolume' => nil, 'CitedPages' => nil, 'NotWantedAfter' => (Date.tomorrow + 1.year).to_s,
      'AcceptNonEnglish' => false, 'AcceptAlternateEdition' => false, 'ArticleExchangeUrl' => nil,
      'ArticleExchangePassword' => nil, 'TransactionStatus' => 'Checked Out to Customer',
      'TransactionDate' => datetime_now.to_s, 'ISSN' => '12345678X', 'ILLNumber' => nil, 'ESPNumber' => nil,
      'LendingString' => nil, 'BaseFee' => nil, 'PerPage' => nil, 'Pages' => nil,
      'DueDate' => (datetime_now + 1.year).to_s, 'RenewalsAllowed' => false, 'SpecIns' => nil, 'Pieces' => nil,
      'LibraryUseOnly' => nil, 'AllowPhotocopies' => false, 'LendingLibrary' => nil,
      'ReasonForCancellation' => 'Cancelled by Customer', 'CallNumber' => nil, 'Location' => nil, 'Maxcost' => nil,
      'ProcessType' => 'Borrowing', 'ItemNumber' => nil, 'LenderAddressNumber' => nil, 'Ariel' => false,
      'Patron' => nil, 'PhotoItemAuthor' => nil, 'PhotoItemPlace' => nil, 'PhotoItemPublisher' => nil,
      'PhotoItemEdition' => nil, 'DocumentType' => nil, 'InternalAcctNo' => nil, 'PriorityShipping' => nil,
      'Rush' => 'Regular', 'CopyrightAlreadyPaid' => 'No', 'WantedBy' => nil, 'SystemID' => 'OCLC',
      'ReplacementPages' => nil, 'IFMCost' => nil, 'CopyrightPaymentMethod' => nil, 'ShippingOptions' => nil,
      'CCCNumber' => nil, 'IntlShippingOptions' => nil, 'ShippingAcctNo' => nil, 'ReferenceNumber' => nil,
      'CopyrightComp' => nil, 'TAddress' => nil, 'TAddress2' => nil, 'TCity' => nil, 'TState' => nil, 'TZip' => nil,
      'TCountry' => nil, 'TFax' => nil, 'TEMailAddress' => nil, 'TNumber' => nil, 'HandleWithCare' => false,
      'CopyWithCare' => false, 'RestrictedUse' => false, 'ReceivedVia' => nil, 'CancellationCode' => nil,
      'BillingCategory' => nil, 'CCSelected' => 'No', 'OriginalTN' => nil, 'OriginalNVTGC' => nil,
      'InProcessDate' => nil, 'InvoiceNumber' => nil, 'BorrowerTN' => nil, 'WebRequestForm' => nil, 'TName' => nil,
      'TAddress3' => nil, 'IFMPaid' => nil, 'BillingAmount' => nil, 'ConnectorErrorStatus' => nil,
      'BorrowerNVTGC' => nil, 'CCCOrder' => nil, 'ShippingDetail' => nil, 'ISOStatus' => nil,
      'OdysseyErrorStatus' => nil, 'WorldCatLCNumber' => nil, 'Locations' => nil, 'FlagType' => nil, 'FlagNote' => nil,
      'CreationDate' => datetime_now.to_s, 'ItemInfo1' => nil, 'ItemInfo2' => nil, 'ItemInfo3' => nil,
      'ItemInfo4' => nil, 'ItemInfo5' => nil, 'SpecialService' => nil, 'DeliveryMethod' => nil, 'Web' => nil,
      'PMID' => nil, 'DOI' => nil, 'LastOverdueNoticeSent' => nil, 'ExternalRequest' => nil
    }
  end
  let(:datetime_now) { DateTime.now }

  it 'has a title' do
    expect(ill_loan.title).to eq 'The Book Title'
  end

  it 'has an author' do
    expect(ill_loan.author).to eq 'Author, Test'
  end

  it 'has a status' do
    expect(ill_loan.status).to eq 'Checked Out to Customer'
  end

  it 'has a due_date' do
    expect(ill_loan.due_date).to eq (datetime_now + 1.year).to_s
  end

  it 'has a creation_date' do
    expect(ill_loan.creation_date).to eq datetime_now.to_s
  end

  context 'when an element does not exist' do
    it 'returns nil' do
      record.except!('DueDate')
      expect(ill_loan.due_date).to eq nil
    end
  end
end