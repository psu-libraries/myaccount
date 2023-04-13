# frozen_string_literal: true

# HTTP response wrapper for requests to ILLiad Web Platform API
class IlliadResponse
  def initialize(current_user_username)
    @current_user_username = current_user_username
  end

  def illiad_holds
    holds = IlliadClient.new.send("get_loan_#{:holds}", @current_user_username)
    (holds.presence || [])
  end

  def illiad_checkouts
    checkouts = IlliadClient.new.send("get_loan_#{:checkouts}", @current_user_username)
    (checkouts.presence || [])
  end

  def ill_recalled
    count = 0
    illiad_checkouts.each do |hold|
      count += 1 if hold.status == 'Recalled, Please Return ASAP'
    end
    count
  end

  def ill_overdue
    count = 0
    illiad_checkouts.each do |hold|
      if hold.due_date.present? && (hold.due_date < Time.now)
        count += 1
      end
    end
    count
  end

  def ill_ready_for_pickup
    count = 0
    illiad_holds.each do |hold|
      count += 1 if hold.status == 'Available for Pickup'
    end
    count
  end
end
