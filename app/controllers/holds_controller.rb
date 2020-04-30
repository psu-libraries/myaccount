# frozen_string_literal: true

class HoldsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_blanks!, only: :create
  rescue_from HoldCreateException, with: :deny_create
  rescue_from HoldException, with: :past_date

  # Render patron holds
  #
  # GET /holds
  def index
    @holds_ready = holds_ready
    @holds_not_ready = holds_not_ready
  end

  # Handles form submission for changing holds in Symphony
  #
  # PATCH /holds
  # PUT /holds
  def batch_update
    params['hold_list'].each do |hold_key|
      ws_args = { hold_key: hold_key, session_token: current_user.session_token }

      if params[:pickup_library].present?
        ChangePickupLibraryJob.perform_later(**ws_args, pickup_library: params[:pickup_library])
      end

      if params[:pickup_by_date].present?
        ChangePickupByDateJob.perform_later(**ws_args, pickup_by_date: params[:pickup_by_date])
      end
    end

    render plain: 'Update scheduled', status: :ok
  end

  # Prepares the form for creating a new hold
  #
  # GET /holds/new
  def new
    form_builder = PlaceHoldForm::Builder.new(catkey: params[:catkey],
                                              user_token: current_user.session_token,
                                              client: symphony_client)
    @place_hold_form_params = form_builder.generate
  end

  # Handles placing holds
  #
  # POST /holds
  def create
    results = barcodes.each_with_object(success: [], error: []) do |barcode, status|
      hold_args = { pickup_library: params['pickup_library'], pickup_by_date: params['pickup_by_date'] }
      response = symphony_client.place_hold(patron,
                                            current_user.session_token,
                                            barcode,
                                            hold_args)
      case response.status
      when 200
        status[:success] << { barcode: barcode,
                              hold_key: JSON.parse(response.body).dig('holdRecord', 'key') }
      else
        Rails.logger.error("Place Hold for #{barcode} by #{patron.barcode}: #{response.body}")
        status[:error] << { barcode: barcode,
                            error_message: JSON.parse(response.body).dig('messageList')[0].dig('message') }
      end
    end

    session[:place_hold_results] = results
    session[:place_hold_catkey] = params['catkey']

    redirect_to result_path
  end

  # Handles place hold response
  #
  # GET /holds/result
  def result
    return redirect_to holds_path if session[:place_hold_results].blank?

    @place_hold_catkey = session[:place_hold_catkey]

    results_builder = PlaceHoldResults::Builder.new(user_token: current_user.session_token,
                                                    client: symphony_client,
                                                    place_hold_results: session[:place_hold_results])
    @place_hold_results = results_builder.generate

    session.delete(:place_hold_catkey)
    session.delete(:place_hold_results)
  end

  # Handles form submission for canceling holds in Symphony
  #
  # DELETE /holds
  def batch_destroy
    params['hold_list'].each do |hold_key|
      ws_args = { hold_key: hold_key, session_token: current_user.session_token }

      CancelHoldJob.perform_later(**ws_args)
    end

    render plain: 'Deletion scheduled', status: :ok
  end

  private

    def holds
      patron.holds
    end

    def holds_ready
      holds.select(&:ready_for_pickup?)
    end

    def holds_not_ready
      holds.reject(&:ready_for_pickup?)
    end

    def process_flash(type, translation)
      flash[type] = "#{flash[type]} #{t "myaccount.hold.#{translation}"}"
    end

    def item_details
      { holdRecordList: true }
    end

    def check_for_blanks!
      return unless barcodes.blank? || params['pickup_library'].blank? || params['pickup_by_date'].blank?

      raise HoldCreateException, 'Error'
    end

    def deny_create
      flash[:error] = if barcodes.blank?
                        t 'myaccount.hold.place_hold.select_volumes'
                      elsif params['pickup_library'].blank?
                        t 'myaccount.hold.place_hold.select_library'
                      else
                        t 'myaccount.hold.place_hold.select_date'
                      end

      redirect_to new_hold_path(catkey: params[:catkey])
    end

    def barcodes
      [params['barcodes']].flatten.compact
    end
end
