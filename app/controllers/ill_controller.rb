# frozen_string_literal: true

class IllController < ApplicationController
  before_action :set_cache_headers
  before_action :authenticate_user!
  before_action :check_for_blanks!, only: :create
  before_action :unless_maintenance_mode, only: :new
  rescue_from NewHoldException, with: :deny_new
  rescue_from HoldCreateException, with: :deny_create

  def new
    raise NewHoldException, 'Error' if params[:catkey].blank?

    if patron.ill_ineligible?
      redirect_to new_hold_path(catkey: params[:catkey])
    else
      @place_loan_form_params = {
        catkey: params[:catkey],
        title: bib_info.title,
        author: bib_info.author
      }

      raise NewHoldException, 'Error' if @place_loan_form_params.blank?
    end
  end

  def create
    transaction_info = IllTransaction.new(patron, bib_info)
    result = IlliadClient.new.place_loan(transaction_info, params)

    if result.status == 200
      # TODO: alert text from Ruth
      flash[:alert] = t('myaccount.hold.place_hold.success_html')

      redirect_to summaries_path
    else
      flash[:error] = t 'myaccount.hold.new_hold.error_html'

      redirect_to new_ill_path
    end
  end

  private

    def bib_info
      @bib_info ||= Bib.new(SymphonyClientParser::parsed_response(
                              symphony_client,
                              :get_bib_info,
                              params[:catkey],
                              current_user.session_token
                            ))
    end

    # def record
    #   bib_info.record
    # end

    def check_for_blanks!
      return if params['pickup_by_date'].present?

      raise HoldCreateException, 'Error'
    end

    def deny_new
      flash[:error] = if params['catkey'].blank?
                        t 'myaccount.hold.new_hold.catkey_missing'
                      else
                        t 'myaccount.hold.new_hold.error_html'
                      end

      redirect_to summaries_path
    end

    def deny_create
      flash[:error] = if params['pickup_by_date'].blank?
                        t 'myaccount.hold.place_hold.select_date'
                      end

      redirect_to new_ill_path(catkey: params[:catkey])
    end
end
