# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  has_many :photos
  has_many :recipients
  has_many :postcards, through: :photos
end
