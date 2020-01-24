# frozen_string_literal: true

class DashboardItemComponent < ActionView::Component::Base
  def initialize(model:, count:, count_term: nil, items: nil)
    @model = model
    @count = count
    @count_term = count_term
    @items = items
  end

  def card_body
    return nil if @items.nil?

    facts = @items.map do |item|
      content_tag :li, "#{item[:count]}  #{item[:label]}"
    end.join

    content_tag :ul, facts, nil, false
  end

  def item_link
    url = url_for(controller: @model.to_s.downcase, action: 'index')

    link_to "See all #{@model}", url, class: 'btn btn-primary float-right'
  end

  def render?
    @count.positive?
  end
end
