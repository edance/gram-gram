class LobWebhookController < ApplicationController
  protect_from_forgery with: :null_session

  http_basic_authenticate_with name: ENV['LOB_WEBHOOK_NAME'],
                               password: ENV['LOB_WEBHOOK_PASSWORD']

  def webhook
    send(method_name)
    render json: {}
  rescue NoMethodError
    logger.warn "LobWebhook: No method for #{method_name}"
    render json: {}
  end

  private

  def method_name
    params[:event_type][:id].tr('.', '_')
  end

  def lob_id
    params[:body][:id]
  end

  def postcard_receipt
    @postcard_receipt ||= PostcardReceipt.find_by_lob_id(lob_id)
  end

  # Events from lob
  # postcard.mailed
  # postcard.in_transit
  # postcard.processed_for_delivery
  # postcard.returned_to_sender

  def postcard_mailed
    postcard_receipt.mailed!
  end

  def postcard_in_transit
    postcard_receipt.in_transit!
  end

  def postcard_processed_for_delivery
    postcard_receipt.delivered!
  end

  def postcard_returned_to_sender
    postcard_receipt.delivery_failed!
  end
end
