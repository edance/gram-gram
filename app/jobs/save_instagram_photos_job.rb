class SaveInstagramPhotosJob < ApplicationJob
  queue_as :default
  attr_accessor :user

  MEDIA_TYPE_IMAGE = 'IMAGE'.freeze
  MEDIA_TYPE_CAROUSEL = 'CAROUSEL_ALBUM'.freeze

  def perform(user_id)
    @user = User.find_by_id(user_id)
    media = user.media['data']
    media.each do |m|
      case m['media_type']
      when MEDIA_TYPE_IMAGE
        create_photo(m)
      when MEDIA_TYPE_CAROUSEL
        create_photos_from_carousel(m)
      end
    end
  end

  def create_photo(photo)
    Photo.create(
      user: user,
      ig_id: photo['id'],
      ig_media_url: photo['media_url'],
      ig_permalink: photo['permalink'],
      ig_caption: photo['caption'],
      ig_timestamp: photo['timestamp']
    )
  end

  def create_photos_from_carousel(media_id)
    # get all the children
    # for each chil, call create_image on it
  end
end
