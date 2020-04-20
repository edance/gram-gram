class SendOrderJob < ApplicationJob
  queue_as :default

  attr_accessor :order

  def perform(order)
    @order = order
    return if order.nil? || !order.pending?

    return unless order.paid?

    send_postcards

    order.completed!
  end

  private

  def send_postcards
    order
      .recipients
      .map { |r| order.postcard_receipts.create(recipient: r) }
      .map(&:send_postcard!)
  end
end
