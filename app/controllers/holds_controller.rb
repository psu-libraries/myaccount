# frozen_string_literal: true

class HoldsController < ApplicationController
  before_action :authenticate_user!
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
      handle_pickup_change_request if params['pickup_library'].present? && params['pickup_library'] != 'Not set'
      handle_not_needed_after_request if params['pickup_by_date'].present?
    end

    redirect_to holds_path
  end

  # Prepares the form for creating a new hold
  #
  # GET /holds/new
  def new
    result = symphony_client.get_bib_info params['catkey'], current_user.session_token
    parsed_body = JSON.parse result.body
    @bib = Bib.new(parsed_body, holdable_locations)
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

    def holdable_locations
      result = symphony_client.retrieve_holdable_locations.body

      parsed_body = JSON.parse result
      parsed_body.filter { |p| p&.dig 'fields', 'holdable' }
        .map { |p| p&.dig 'key' }
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
end
