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
end
