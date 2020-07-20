class SaveInstagramPhotosJob < ApplicationJob
  queue_as :default
  attr_accessor :user

  def perform(user)
    @user = user
    broadcast_started

    InstagramService.new(user).photos.each do |photo|
      create_photo(photo)
    end

    broadcast_ended
  end

  def create_photo(ig_photo)
    photo = user.photos.find_or_initialize_by(ig_id: ig_photo['id'])
    photo.update(
      ig_caption: ig_photo['caption'],
      ig_media_url: ig_photo['media_url'],
      ig_permalink: ig_photo['permalink'],
      ig_timestamp: ig_photo['timestamp']
    )
  end

  def broadcast_started
    ActionCable.server.broadcast("photos_for_#{user.id}", started: 1)
  end

  def broadcast_ended
    ActionCable.server.broadcast("photos_for_#{user.id}", ended: 1)
  end
end
