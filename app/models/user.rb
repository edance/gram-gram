# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :photos, dependent: :destroy
  has_many :recipients, dependent: :destroy
  has_many :postcards, through: :photos

  after_create :create_payment_customer

  def instagram?
    instagram_uid.present?
  end

  private

  def create_payment_customer
    CreateCustomerJob.perform_later(self)
  end
end
