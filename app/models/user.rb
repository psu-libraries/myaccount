# frozen_string_literal: true

# Class to model User information
class User
  include ActiveModel::Model
  attr_accessor :username, :name, :patron_key, :session_token, :library

  def initialize(attributes)
    super(attributes.with_indifferent_access.slice(:username, :name, :patron_key, :session_token, :library))
  end

  def library_ill_path_key
    library == 'HERSHEY' ? 'mhy' : 'upm'
  end
end
