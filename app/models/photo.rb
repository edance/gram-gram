# frozen_string_literal: true

# A photo that could be featured on a Postcard
class Photo < ApplicationRecord
  has_many :postcards, dependent: :destroy
  belongs_to :user
  validates_uniqueness_of :ig_id

  self.per_page = 18 # divisible by 2 & 3
end
