class LobWebhookController < ApplicationController
  http_basic_authenticate_with name: ENV['LOB_WEBHOOK_NAME'],
                               password: ENV['LOB_WEBHOOK_PASSWORD']

  def webhook
    event = params.permit!.to_h
    LobWebhookJob.perform_later(event)
    render json: {}
  end
end
