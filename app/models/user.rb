# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  has_many :photos
  has_many :recipients
end
