class SaveInstagramPhotosJob < ApplicationJob
  queue_as :default
  attr_accessor :user, :instagram_photos

  def perform(user)
    @user = user
    @instagram_photos = user&.instagram_photos
    instagram_photos&.each do |photo|
      create_photo(photo)
      broadcast_photo_count
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

  def broadcast_photo_count
    PhotosChannel.broadcast_to(
      user,
      total_photo_count: instagram_photos.size,
      processed_photo_count: Photo.where(user: user).count
    )
  end
end
