class Postcard < ApplicationRecord
  belongs_to :recipient
  belongs_to :photo

  enum status: %i[in_transit in_local_area processed_for_delivery re_routed
                  returned_to_sender]

  PRICE = 300

  def lob_description
    "postcard_id_#{id}"
  end
end
