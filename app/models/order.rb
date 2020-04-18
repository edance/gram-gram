class Order < ApplicationRecord
  belongs_to :photo

  has_many :postcards
  has_many :recipients
end
