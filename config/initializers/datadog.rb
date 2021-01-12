# frozen_string_literal: true

if Settings&.datadog&.on_server
  require 'ddtrace'
  Datadog.configure do |c|
    c.service = 'myaccount'
    c.env = Settings.datadog.environment
    c.use :rails
    c.use :httprb, service_name: 'myaccount-httprb'
    c.use :sidekiq, service_name: 'myaccount-sidekiq'
    c.use :redis, service_name: 'myaccount-redis'
  end

  # Monkey patching Datadog
  Datadog::Contrib::Httprb::Instrumentation::InstanceMethods.module_eval do
    private

      def annotate_span_with_response!(span, response)
        return unless response&.code

        span.set_tag(Datadog::Ext::HTTP::STATUS_CODE, response.code)

        case response.code.to_i
        when 400...599
          begin
            message = JSON.parse(response.body)['messageList']
          rescue StandardError
            message = 'Error'
          end
          span.set_error(["Error #{response.code}", message]) unless message.first['code'] == 'hatErrorResponse.116'
        end
      end
  end
end
