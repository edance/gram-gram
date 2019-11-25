# @class LobWebhookJob
# @author Evan Dancer
class LobWebhookJob < ApplicationJob
  queue_as :default

  attr_accessor :event

  def perform(event)
    @event = event
    # get the callback function
    method_name = event[:event_type][:id].tr('.', '_')
    send(method_name)
  rescue NoMethodError
    logger.warn "LobWebhookJob: No method for #{method_name}"
  end

  def check_processed_for_delivery
    transaction = PayoutTransaction.find_by_lob_id(event['body']['id'])
    payout = transaction.try(:payout)
    return if payout.nil?

    payout.complete!
  end
end
