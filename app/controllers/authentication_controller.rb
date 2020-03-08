# frozen_string_literal: true

class AuthenticationController < ApplicationController
  before_action :authenticate_user!

  def authorize
    base_url = 'https://api.instagram.com/oauth/authorize'
    query = {
      app_id: ENV['INSTAGRAM_ID'],
      redirect_uri: ENV['INSTAGRAM_REDIRECT_URI'],
      scope: 'user_profile,user_media',
      response_type: 'code'
    }
    redirect_to "#{base_url}?#{query.to_query}"
  end

  def callback
    resp = fetch_access_token
    attrs = JSON.parse(resp.body)
    current_user.instagram_uid = attrs['user_id']
    current_user.instagram_access_token = attrs['access_token']
    update_user_information!
    load_recent_photos

    redirect_to photos_path
  end

  private

  def code
    params.require(:code)
  end

  def load_recent_photos
    SaveInstagramPhotosJob.set(wait: 5.seconds).perform_later(current_user)
  end

  def update_user_information!
    info = InstagramService.new(current_user).user_information
    current_user.update!(
      ig_username: info['username'],
      ig_avatar: info['profile_pic_url'],
      private_profile: info['is_private'],
      sync_at: DateTime.now
    )
  end

  def fetch_access_token
    url = 'https://api.instagram.com/oauth/access_token'
    Faraday.post(url,
                 app_id: ENV['INSTAGRAM_ID'],
                 app_secret: ENV['INSTAGRAM_SECRET'],
                 grant_type: 'authorization_code',
                 redirect_uri: ENV['INSTAGRAM_REDIRECT_URI'],
                 code: code)
  end
end
