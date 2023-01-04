# frozen_string_literal: true

class PlaceLoanSuccessComponent < ViewComponent::Base
  def initialize(result:)
    @result = result
    @bib_item = OpenStruct.new(result[:bib])
  end

  def issn
    result&.dig 'issn'
  end

  def not_wanted_after
    l(Date.parse(result&.dig('not_wanted_after'), '%Y-%m-%d'), format: :long)
  end

  def accept_alternate_edition
    result&.dig('accept_alternate_edition') ? 'Yes' : 'No'
  end

  def accept_ebook
    result&.dig('accept_ebook') ? 'Yes' : 'No'
  end

  def render?
    result.present?
  end

  private

    attr_reader :result, :bib_item
end
