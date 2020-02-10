# frozen_string_literal: true

# Model for bib-level information in Symphony, it's basically a hold request factory
class Bib
  include BibRecord
  attr_reader :body

  def initialize(body)
    @body = body
  end

  def self.generate_holds(body)
    items = body.dig('fields', 'callList')

    items.map { |item_info| Hold.new item_info }
  end

  private

    def bib
      @body['fields']
    end
end
