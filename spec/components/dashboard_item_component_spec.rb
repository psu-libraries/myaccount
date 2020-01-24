# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardItemComponent, type: :component do
  let(:dashboard_item_args) { { model: 'Checkouts',
                                count: 50,
                                count_term: 'Total checked out',
                                items: [
                                  {
                                    label: 'recalled',
                                    count: 2
                                  },
                                  {
                                    label: 'overdue',
                                    count: 3
                                  }
                                ] }}

  it 'makes a list' do
    component = render_inline(described_class, dashboard_item_args).to_html
    expect(component).to include '<li>2  recalled</li>'
  end

  it 'links to a model path' do
    component = render_inline(described_class, dashboard_item_args).to_html
    expect(component).to include 'href="/checkouts"'
  end

  it 'doesn\'t render if count is not positive' do
    dashboard_item_args[:count] = 0
    component = render_inline(described_class, dashboard_item_args).to_html
    expect(component).to be_empty
  end

  it 'doesn\'t render items if there aren\'t any items' do
    dashboard_item_args[:items] = nil
    component = render_inline(described_class, dashboard_item_args).to_html
    expect(component).not_to include '<ul>'
  end
end
