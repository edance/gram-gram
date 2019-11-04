# frozen_string_literal: true

# Someone who receives a postcard and their mailing information
class Recipient < ApplicationRecord
  has_many :postcards
  belongs_to :user
end
