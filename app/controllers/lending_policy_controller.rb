# frozen_string_literal: true

class LendingPolicyController < ApplicationController
  before_action :authenticate_user!

  def accept
    if patron.eligible_for_wage_garnishment?
      byebug
      client = SymphonyClient.new
      response = client.accept_lending_policy(patron: patron, session_token: current_user.session_token)
      byebug
      if response.status == 200
        redirect_to lending_policy_thank_you_path
      else
        redirect_to lending_policy_error_path
      end
    else
      # even if the patron is not eligible for wage garnishment (already opted in or some other reason),
      # just redirect them to the thank you path to avoid further user confusion
      redirect_to lending_policy_thank_you_path
    end
  end
end
