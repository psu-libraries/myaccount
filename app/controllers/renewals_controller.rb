# frozen_string_literal: true

# Controller for renewing items
class RenewalsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :authenticate_user!
  before_action :renew_params, only: :create
  before_action :authorize_update!, only: :create
  rescue_from RenewalException, with: :deny_access

  RENEWAL_FLASH_LIMIT = 25

  # Renew items for a patron
  #
  # POST /renewals
  def create
    @renew_items_response = symphony_client.renew_items(current_user, checkouts_to_renew)

    if checkouts_to_renew.length > RENEWAL_FLASH_LIMIT
      bulk_renewal_summary_flash(@renew_items_response, :success)
      bulk_renewal_summary_flash(@renew_items_response, :error)
    else
      bulk_renewal_flash(@renew_items_response, :success)
      bulk_renewal_flash(@renew_items_response, :error)
    end

    redirect_to checkouts_path
  end

  private

    def item_details
      { circRecordList: true }
    end

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

    def bulk_renewal_summary_flash(response, type)
      return unless response[type].any?

      flash[type] = I18n.t("renew_all_items_summary.#{type}_html", count: response[type].length)
    end

    def renewal_prompt(renewal)
      if renewal.respond_to?(:each)
        renewal_obj, error_message = renewal

        non_renewal_reason = error_prompt error_message
        renewal_obj.bib_summary + (non_renewal_reason || '')
      else
        renewal.bib_summary
      end
    end

    def error_prompt(error_message)
      return if error_message.empty?

      content_tag(:div, "Denied: #{error_message}")
    end
end
