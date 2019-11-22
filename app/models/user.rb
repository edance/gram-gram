# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  has_many :photos
  has_many :recipients
  has_many :postcards, through: :photos

  after_commit :save_customer

  private

  def save_customer
    PaymentProcessor.create_or_update_customer(self)
  end
end
