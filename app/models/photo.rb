# frozen_string_literal: true

# A photo that could be featured on a Postcard
class Photo < ApplicationRecord
  has_many :postcards
  belongs_to :user
end
