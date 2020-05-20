# frozen_string_literal: true

class CheckoutsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :authenticate_user!
  before_action :renew_params, only: :batch_update
  before_action :authorize_update!, only: :batch_update
  rescue_from RenewalException, with: :deny_access

  # Render a list of checkouts and renewals for patron
  #
  # GET /checkouts
  def index
    ws_args = { patron_key: current_user.patron_key, session_token: current_user.session_token }
    ViewCheckoutsJob.perform_later **ws_args

    @patron_key = current_user.patron_key
    render
  end

  # Handles form submission for renewals in Symphony
  #
  # PATCH /renewals
  def batch_update
    checkouts_to_renew.each do |checkout|
      ws_args = { resource: checkout.resource,
                  item_key: checkout.item_key,
                  session_token: current_user.session_token }
      RenewCheckoutJob.perform_later(**ws_args)
    end

    render plain: 'Renew', status: :ok
  end

  private

    def checkouts_to_renew
      patron.checkouts.select { |checkout| renew_params.include? checkout.item_key }
    end

    def renew_params
      if params[:renewal_list].blank?
        flash[:notice] = 'No items were selected for renewal.'

        redirect_to checkouts_path
      else
        params[:renewal_list]
      end
    end

    def authorize_update!
      return unless checkouts_to_renew.empty?

      raise RenewalException, 'Error'
    end

    def deny_access
      flash[:error] = 'An unexpected error has occurred'

      redirect_to checkouts_path
    end
end
