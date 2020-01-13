# frozen_string_literal: true

# Controller for renewing items
class RenewalsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :authenticate_user!
  before_action :authorize_update!, only: :create
  rescue_from RenewalException, with: :deny_access

  # Renew items for a patron
  #
  # POST /renewals
  def create
    @renew_items_response = symphony_client.renew_items(current_user, renewal_list)

    bulk_renewal_flash(@renew_items_response, :success)
    bulk_renewal_flash(@renew_items_response, :error)

    redirect_to checkouts_path
  end

  private

    def item_details
      { circRecordList: true }
    end

    def renewal_list
      patron.checkouts.select { |checkout| renew_params.include? checkout.item_key }
    end

    def renew_params
      params.require(:renewal_list)
    end

    def authorize_update!
      return unless renewal_list.empty?

      raise RenewalException, 'Error'
    end

    def deny_access
      flash[:error] = 'An unexpected error has occurred'

      redirect_to checkouts_path
    end

    def bulk_renewal_flash(response, type)
      return unless response[type].any?

      flash[type] = I18n.t(
        "renew_all_items.#{type}_html",
        count: response[type].length,
        items: content_tag(
          :ul,
          safe_join(response[type].map do |renewal|
            content_tag(:li,
                        renewal_prompt(renewal),
                        {},
                        false)
          end, '')
        )
      )
    end

    def renewal_prompt(renewal)
      renewal.respond_to?(:each) ? renewal[0].title + error_prompt(renewal[1]) : renewal.title
    end

    def error_prompt(error_message)
      content_tag(:div, "Denied: #{error_message}")
    end
end
