# frozen_string_literal: true

class SelectAllComponent < ViewComponent::Base
  def initialize(target_keyword:)
    @target_keyword = target_keyword
    @name = "#{target_keyword}_all"
  end

  private

    attr_reader :name, :target_keyword
end
