class CreateCustomerJob < ApplicationJob
  queue_as :default

  def perform(user)
    return if user.payment_customer_id.present?

    customer = PaymentProcessor.create_customer(user)
    user.update(payment_customer_id: customer.id)
  end
end
