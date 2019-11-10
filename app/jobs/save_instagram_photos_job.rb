class SaveInstagramPhotosJob < ApplicationJob
  queue_as :default
  attr_accessor :user

  def perform(user_id)
    @user = User.find_by_id(user_id)
    user.photos&.each { |p| create_photo(p) }
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
