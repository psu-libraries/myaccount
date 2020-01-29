# frozen_string_literal: true

class SelectAllChildComponent < ActionView::Component::Base
  def initialize(type:, key:, name: nil)
    @name = name
    @key = key
    @type = type
  end

  def final_name
    @name ||= @type

    "#{@name}_list[]"
  end

  private

    attr_reader :name, :type, :key
end
