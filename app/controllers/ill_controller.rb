# frozen_string_literal: true

class IllController < ApplicationController
  before_action :set_cache_headers
  before_action :authenticate_user!
  before_action :check_for_blanks!, only: :create
  before_action :unless_maintenance_mode, only: :new
  rescue_from NewHoldException, with: :deny_new
  rescue_from HoldCreateException, with: :deny_create

  # Prepares the form for creating a new loan
  #
  # GET /ill/new
  def new
    raise NewHoldException, 'Error' if params[:catkey].blank?

    if patron.ill_ineligible?
      redirect_to new_hold_path(catkey: params[:catkey])
    else
      form_builder = PlaceHoldForm::Builder.new(catkey: params[:catkey],
                                                user_token: current_user.session_token,
                                                client: symphony_client,
                                                library: patron.library)

      @place_loan_form_params = form_builder.generate

      raise NewHoldException, 'Error' if @place_loan_form_params.blank?
    end
  end

  # Handles placing loan
  #
  # POST /ill
  def create
    transaction_info = IllTransaction.new(patron, bib_info)
    response = IlliadClient.new.place_loan(transaction_info, params)

    bib = {
      catkey: params[:catkey],
      title: bib_info.title,
      author: bib_info.author,
      shadowed: bib_info.shadowed?
    }

    place_loan_result = {
      catkey: params[:catkey]
    }

    if response.status == 200
      place_loan_result[:success] = {
        bib:,
        issn: transaction_info.isbn,
        not_wanted_after: params[:pickup_by_date],
        accept_alternate_edition: params[:accept_alternate_edition],
        accept_ebook: params[:accept_ebook]
      }
    else
      place_loan_result[:error] = {
        bib:,
        error_message: 'Interlibrary Loan Request Failed'
      }
    end

    write_to_redis(place_loan_result)

    redirect_to ill_result_path
  end

  # Handles place loan response
  #
  # GET /ill/result
  def result
    @place_loan_result = read_from_redis.fetch('result', {}).with_indifferent_access
    redirect_to '/not_found' if @place_loan_result.nil?

    @bib = OpenStruct.new(@place_loan_result.dig('success', 'bib') || @place_loan_result.dig('error', 'bib'))

    if request.referer && URI(request.referer).path == '/ill/new'
      render
    else
      redirect_to '/not_found'
    end
  end

  private

    def bib_info
      @bib_info ||= Bib.new(SymphonyClientParser::parsed_response(
                              symphony_client,
                              :get_bib_info,
                              catkey: params[:catkey],
                              session_token: current_user.session_token
                            ))
    end

    def write_to_redis(result)
      Redis.current.set("place_loan_results_#{patron.key}", {
        id: patron.barcode.to_s,
        result:
      }.to_json)
    end

    def read_from_redis
      result = Redis.current.get("place_loan_results_#{patron.key}")
      return {} if result.nil?

      JSON.parse(result)
    end

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
