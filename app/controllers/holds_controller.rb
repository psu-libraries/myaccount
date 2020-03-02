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
  def update
    params['hold_list'].each do |holdkey|
      @hold_to_act_on = holds.find { |hold| hold.key == holdkey }
      handle_pickup_change_request if params['pickup_library'].present? && params['pickup_library'].present?
      handle_not_needed_after_request if params['pickup_by_date'].present?
    end

    redirect_to holds_path
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
    session.delete(:place_hold_catkey)

    raw_place_hold_results = session[:place_hold_results]
    session.delete(:place_hold_results)

    @place_hold_results = raw_place_hold_results.each do |status, results|
      if status == 'success'
        results.map { |result| result['placed_hold'] = hold_lookup(result['hold_key']) }
      else
        results.map { |result| result['failed_hold'] = item_lookup(result['barcode']) }
      end
    end
  end

  # Handles form submission for canceling holds in Symphony
  #
  # DELETE /holds
  def destroy
    params['hold_list'].each do |holdkey|
      @hold_to_act_on = holds.find { |hold| hold.key == holdkey }
      response = symphony_client.cancel_hold(holdkey, current_user.session_token)

      case response.status
      when 200
        process_flash(:success, 'cancel.success_html')
      else
        Rails.logger.error(response.body)
        process_flash(:error, 'cancel.error_html')
      end
    end

    redirect_to holds_path
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

    def handle_pickup_change_request
      change_pickup_response = symphony_client.change_pickup_library(
        hold_key: @hold_to_act_on.key,
        pickup_library: params['pickup_library'],
        session_token: current_user.session_token
      )
      case change_pickup_response.status
      when 200
        process_flash(:success, 'update_pickup.success_html')
      else
        Rails.logger.error(change_pickup_response.body)
        process_flash(:error, 'update_pickup.error_html')
      end
    end

    def handle_not_needed_after_request
      raise HoldException, 'Error' if Date.parse(params['pickup_by_date']) < Date.today

      not_needed_after_response = symphony_client.not_needed_after(
        hold_key: @hold_to_act_on.key,
        fill_by_date: params['pickup_by_date'],
        session_token: current_user.session_token
      )
      case not_needed_after_response.status
      when 200
        process_flash(:success, 'update_not_needed_after.success_html')
      else
        Rails.logger.error(not_needed_after_response.body)
        process_flash(:error, 'update_not_needed_after.error_html')
      end
    end

    def process_flash(type, translation)
      flash[type] = "#{flash[type]} #{t "myaccount.hold.#{translation}", bib_summary: @hold_to_act_on.bib_summary}"
    end

    def item_details
      { holdRecordList: true }
    end

    def past_date
      flash[:error] = t 'myaccount.hold.update_pickup.past_date'

      redirect_to holds_path
    end

    def hold_lookup(hold_key)
      hold_record = symphony_client.get_hold_info hold_key, current_user.session_token
      parsed_hold = JSON.parse hold_record.body
      Hold.new parsed_hold
    end

    def item_lookup(barcode)
      item_record = symphony_client.get_item_info barcode, current_user.session_token
      parsed_item = JSON.parse item_record.body
      Item.new parsed_item
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
