class SaveInstagramPhotosJob < ApplicationJob
  queue_as :default
  attr_accessor :user, :instagram_photos

  def perform(user)
    @user = user
    @instagram_photos = user&.instagram_photos
    instagram_photos&.each do |photo|
      create_photo(photo)
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
end
