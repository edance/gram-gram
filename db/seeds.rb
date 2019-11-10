user = User.find_or_create_by(
  name: 'Grandma',
  email: 'grandma@aol.com',
  instagram_uid: '17841401619133950'
)

photo = Photo.find_or_create_by(
  ig_media_url: 'https://www.fillmurray.com/200/300',
  user: user
)

recipient = Recipient.find_or_create_by(
  user: user,
  name: 'Grandma',
  address_line1: '400 Brannan St',
  address_line2: 'Apt B',
  address_city: 'San Francisco',
  address_state: 'CA',
  address_zip: '94109'
)

postcard = Postcard.find_or_create_by(
  recipient: recipient,
  photo: photo,
  status: 0,
  delivery_date: Date.today,
  lob_id: nil,
  caption: 'Hello Grandma!'
)
