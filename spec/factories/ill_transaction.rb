# frozen_string_literal: true

FactoryBot.define do
  factory :ill_transaction do
    factory :ill_transaction_without_isbn do
      initialize_with { new(patron, bib_info) }

      patron { Patron.new('fields' => { 'alternateID' => 'xyz123' }) }

      bib_info { build(:bib_with_holdables) }
    end

    factory :ill_transaction_with_isbn do
      initialize_with { new(patron, bib_info) }

      patron { Patron.new('fields' => { 'alternateID' => 'xyz123' }) }

      bib_info { build(:bib_with_isbn) }
    end
  end
end
