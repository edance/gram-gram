# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :photos, dependent: :destroy
  has_many :recipients, dependent: :destroy
  has_many :postcards, through: :photos

  def instagram?
    instagram_uid.present?
  end

  def stripe_customer
    @stripe_customer ||=
      payment_customer_id ? retrieve_stripe_customer : create_stripe_customer
  end

  def add_default_stripe_source(source)
    customer = Stripe::Customer.update(
      stripe_customer.id,
      source: source
    )
    @stripe_customer = customer
  end

  private

  def create_stripe_customer
    customer = Stripe::Customer.create(
      email: email,
      name: ig_username
    )

    update(payment_customer_id: customer.id)
    customer
  end

  def retrieve_stripe_customer
    Stripe::Customer.retrieve(payment_customer_id)
  end

  def after_confirmation
    UserMailer.with(user: self).welcome_email.deliver_later
  end
end
