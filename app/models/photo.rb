# frozen_string_literal: true

# A photo object from Instagram
class Photo < ApplicationRecord
  belongs_to :user
end
