# frozen_string_literal: true

# Controller for renewing items
class RenewalsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :authenticate_user!

  # Renew items for a patron
  #
  # POST /renewals
  def create
    @response = symphony_client.renew_items(current_user,renewal_list)

    bulk_renewal_flash(@response, :success)
    bulk_renewal_flash(@response, :error)

    redirect_to checkouts_path
  end

  private

  def item_details
    { circRecordList: true }
  end

  def renewal_list
    patron.checkouts.select { |checkout| params[:renewal_list].include? checkout.catkey }
  end

  def bulk_renewal_flash(response, type)
    return unless response[type].any?

    flash[type] = I18n.t(
      "renew_all_items.#{type}_html",
      count: response[type].length,
      items: content_tag(
        'ul',
        safe_join(response[type].collect { |renewal| content_tag('li', renewal.title) }, '')
      )
    )
  end


end