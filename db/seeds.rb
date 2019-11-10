user = User.find_or_create_by(
  name: 'Grandma',
  email: 'grandma@aol.com',
  instagram_uid: '17841401619133950'
)

photo = Photo.find_or_create_by(
  ig_media_url: 'https://scontent.xx.fbcdn.net/v/t51.2885-15/29415885_2050287158573564_7888298542568046592_n.jpg?_nc_cat=109&_nc_oc=AQkSm4jIjfe-HSC-D6iY5Md3G5O0ABHTqvGPNcZRpeB57Mt5HTyAaM8iNTIhqPmsBEM&_nc_ht=scontent.xx&oh=a96e278dfc5569b87a217fc16eec9aaa&oe=5E401E7A',
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
