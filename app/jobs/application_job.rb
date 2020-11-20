# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # Using ActiveJob to manage retries, only if there's a HTTP related problem. Using 0 seconds because AJ adds jitter
  # time. In reality "1 second" can be up to 5 and 0 is around 1-2.
  retry_on(HTTP::Error, wait: 0.seconds, attempts: 2)
  # Telling Sidekiq to discard jobs instead of retrying (job failed twice already)
  sidekiq_options retry: false

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
