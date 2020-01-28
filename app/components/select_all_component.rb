# frozen_string_literal: true

class SelectAllComponent < ActionView::Component::Base
  def initialize(data_select:)
    @name = "#{data_select}_list[]"
    @data_select = data_select
  end

  private

    attr_reader :name, :data_select
end
