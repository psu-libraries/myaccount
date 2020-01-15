# frozen_string_literal: true

class HoldsController < ApplicationController
  before_action :authenticate_user!

  # Render patron holds
  #
  # GET /holds
  def index
    @holds_ready = holds_ready
    @holds_not_ready = holds_not_ready
  end

  # Handles form submission for canceling requests/holds/etc in Symphony
  #
  # DELETE /holds
  def destroy
    params['hold_list'].each do |holdkey|
      hold_obj = holds.find { |hold| hold.key == holdkey }
      hold_title = hold_obj.title
      response = symphony_client.cancel_hold(holdkey, current_user.session_token)

      case response.status
      when 200
        flash[:success] = "#{flash[:success]} #{t 'myaccount.hold.cancel.success_html', title: hold_title}<br>"
      else
        Rails.logger.error(response.body)
        flash[:errors] = "#{flash[:success]} #{t 'myaccount.hold.cancel.error_html', title: hold_title}"
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

    def item_details
      { holdRecordList: true }
    end
end
