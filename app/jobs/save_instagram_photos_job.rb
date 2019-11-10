class SaveInstagramPhotosJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.instagram_photos&.each do |photo|
      Photo.create(
        user: user,
        ig_id: photo['id'],
        ig_media_url: photo['media_url'],
        ig_permalink: photo['permalink'],
        ig_caption: photo['caption'],
        ig_timestamp: photo['timestamp']
      )
    end
  end
end
