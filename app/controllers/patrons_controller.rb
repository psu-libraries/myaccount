# frozen_string_literal: true

class PatronsController < ApplicationController
  before_action :set_patron, only: [:show, :edit, :update]
  before_action :authenticate_user!
  before_action :unless_maintenance_mode, only: [:edit, :update]
  rescue_from PatronArgumentError, with: :handle

  # GET /patrons/1
  def show; end

  # GET /patrons/1/edit
  def edit; end

  # PATCH/PUT /patrons/1
  def update
    raise PatronArgumentError, 'Error' if %w{first_name last_name street1 city state zip}.find { |p| params[p].empty? }

    client = SymphonyClient.new
    client.update_patron_info patron: patron, params: params, session_token: current_user.session_token
    redirect_to action: 'show'
  end

  private

    def item_details
      { address1: true }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_patron
      @patron = patron
    end

    def handle
      flash[:error] = 'You are missing one of the required fields, please try your edit again.'

      redirect_to edit_patron_path
    end
end
