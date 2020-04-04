# frozen_string_literal: true

# A photo that could be featured on a Postcard
class Photo < ApplicationRecord
  has_many :postcards, dependent: :destroy
  belongs_to :user

  validates :user, presence: true
  validates :ig_id, uniqueness: { scope: :user }

  self.per_page = 48 # divisible by 2, 4, 6
end
