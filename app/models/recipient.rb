# frozen_string_literal: true

# Someone who receives a postcard and their mailing information
class Recipient < ApplicationRecord
  has_many :postcards
  belongs_to :user

  validates_presence_of :name,
                        :address_line1,
                        :address_city,
                        :address_state,
                        :address_zip

  def address
    {
      name: name,
      address_line1: address_line1,
      address_line2: address_line2,
      address_city: address_city,
      address_state: address_state,
      address_zip: address_zip
    }
  end
end
