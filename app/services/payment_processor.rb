class PaymentProcessor
  def self.create_customer(user)
    Stripe::Customer.create(
      name: user.name,
      email: user.email
    )
  end

  def self.create_payment_method(user, token)
    payment_method = Stripe::PaymentMethod.create(
      type: 'card',
      card: { token: token }
    )
    Stripe::PaymentMethod.attach(
      payment_method.id,
      customer: user.payment_customer_id
    )
    payment_method
  end
end
