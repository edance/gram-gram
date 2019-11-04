class Postcard < ApplicationRecord
  belongs_to :recipient
  belongs_to :photo
end
