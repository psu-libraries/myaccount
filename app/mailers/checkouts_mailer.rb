# frozen_string_literal: true

class CheckoutsMailer < ActionMailer::Base
  def export_checkouts(username, checkouts)
    @username = username
    @checkouts = checkouts
    mail to: "#{@username}@psu.edu",
         subject: t('myaccount.checkout_email_subject'),
         from: 'noreply@psu.edu'
  end

  def export_ill_checkouts(username, ill_checkouts)
    @username = username
    @ill_checkouts = ill_checkouts
    mail to: "#{@username}@psu.edu",
         subject: t('myaccount.ill_checkout_email_subject'),
         from: 'noreply@psu.edu'
  end
end
