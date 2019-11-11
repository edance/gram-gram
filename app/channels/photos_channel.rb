class PhotosChannel < ApplicationCable::Channel
  def subscribed
    # current_user is always nil here
    stream_from "photos_for_#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
