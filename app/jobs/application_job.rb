# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  sidekiq_options retry: 1
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  #
  private

    def symphony_client
      @symphony_client || SymphonyClient.new
    end

    def badge(message: message)
      ApplicationController.renderer.render(
        partial: 'shared/success_badge',
        locals: { message: message }
      )
    end
end
