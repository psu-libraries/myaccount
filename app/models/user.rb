# frozen_string_literal: true

# Class to model User information
class User
  include ActiveModel::Model
  attr_accessor :username, :name, :patronKey

  def initialize(attributes)
    super(attributes.with_indifferent_access.slice(:username, :name, :patronKey))
  end
end
