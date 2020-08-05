# frozen_string_literal: true

class SelectAllChildComponent < ViewComponent::Base
  def initialize(name: nil, key:, target_keyword:)
    @name = name || "#{target_keyword}_list[]"
    @key = key
    @target_keyword = target_keyword
  end

  private

    attr_reader :name, :target_keyword, :key
end
