# frozen_string_literal: true

class CheckoutsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :set_cache_headers
  before_action :authenticate_user!

  # Render a list of checkouts and renewals for patron
  #
  # GET /checkouts
  def index
    @username = current_user.username
    Bugsnag.notify(current_user.username)
    ws_args = { patron_key: current_user.patron_key, session_token: current_user.session_token }
    ViewCheckoutsJob.perform_later **ws_args
    ill_args = { webaccess_id: @username, type: :checkouts, library_key: patron.library_ill_path_key }
    ViewIlliadLoansJob.perform_later(**ill_args)

    @patron_key = current_user.patron_key
    render
  end

  # Handles form submission for batch checkout renewal requests
  #
  # PATCH /checkouts/batch
  def batch_update
    checkouts_to_renew&.each do |checkout|
      ws_args = { resource: '/catalog/item',
                  item_key: checkout,
                  session_token: current_user.session_token }
      RenewCheckoutJob.perform_later(**ws_args)
    end

    render plain: 'Renew', status: :ok
  end

  def export_ill_ris
    ris_string = ''
    ill_checkouts = IlliadClient.new.send(:get_loan_checkouts, current_user.username)

    ill_checkouts.each_with_index do |checkout, _i|
      ris_string += tag_format('TY', checkout.type)
      ris_string += tag_format('TI', checkout.title)
      ris_string += tag_format('A1', checkout.author)
      ris_string += tag_format('PY', checkout.date)
      ris_string += tag_format('SN', checkout.identifier)
      ris_string += tag_format('Y2', Time.now.strftime('%Y-%m-%d'))
      ris_string += tag_format('ET', checkout.edition)
      ris_string += "ER  -\r\n"
    end

    send_data ris_string, filename: 'document.ris', type: :ris
  end

  def export_checkouts_email
    response = symphony_client.patron_info(patron_key: current_user.patron_key,
                                           session_token: current_user.session_token,
                                           item_details: { circRecordList: true })

    patron = Patron.new(response)

    checkouts = patron.checkouts.map do |c|
      {
        catkey: c.catkey,
        title: c.title,
        author: c.author,
        call_number: c.call_number
      }
    end

    begin
      CheckoutsMailer.export_checkouts(current_user.username, checkouts).deliver_now
      flash[:success] = I18n.t('myaccount.email.success')
    rescue StandardError
      flash[:error] = I18n.t('myaccount.email.error')
    end

    redirect_to '/checkouts'
  end

  def export_ill_checkouts_email
    ill_checkouts = []
    raw_ill_checkouts = IlliadClient.new.send(:get_loan_checkouts, current_user.username)
    raw_ill_checkouts.each do |checkout|
      checkout_data = {
        title: checkout.title,
        author: checkout.author,
        date: checkout.date,
        identifier: checkout.identifier
      }
      ill_checkouts.push(checkout_data)
    end

    begin
      CheckoutsMailer.export_ill_checkouts(current_user.username, ill_checkouts).deliver_now
      flash[:success] = I18n.t('myaccount.email.success')
    rescue StandardError
      flash[:error] = I18n.t('myaccount.email.error')
    end

    redirect_to '/checkouts'
  end

  private

    def checkouts_to_renew
      params['renewal_list']
    end

    def deny_access
      flash[:error] = 'An unexpected error has occurred'

      redirect_to checkouts_path
    end

    def tag_format(tag, value)
      return '' unless value

      "#{tag}  - #{value}\r\n"
    end
end
