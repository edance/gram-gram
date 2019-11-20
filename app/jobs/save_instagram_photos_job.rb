class SaveInstagramPhotosJob < ApplicationJob
  queue_as :default
  attr_accessor :user, :instagram_photos

  def perform(user)
    @user = user
    broadcast_started

    @instagram_photos = user&.instagram_photos
    instagram_photos&.each do |photo|
      create_photo(photo)
    end

    broadcast_ended
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

  def broadcast_started
    ActionCable.server.broadcast("photos_for_#{user.id}", started: 1)
  end

  def broadcast_ended
    ActionCable.server.broadcast("photos_for_#{user.id}", ended: 1)
  end
end
