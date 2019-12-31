# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :photos, dependent: :destroy
  has_many :recipients, dependent: :destroy
  has_many :postcards, through: :photos

  after_commit :save_customer

  private

  def save_customer
    PaymentProcessor.create_or_update_customer(self)
  end
end
