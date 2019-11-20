# frozen_string_literal: true

class AuthenticationController < ApplicationController
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
    user = User.find_or_initialize_by(instagram_uid: attrs['user_id'])
    user.instagram_access_token = attrs['access_token']
    update_user_information!(user)
    session[:current_user_id] = user.id
    cookies.encrypted[:user_id] = current_user.id

    SaveInstagramPhotosJob.perform_later(current_user)

    redirect_to photos_path
  end

  def logout
    reset_session
    redirect_to root_path
  end

  private

  def code
    params.require(:code)
  end

  def update_user_information!(user)
    info = user.user_information
    user.update!(ig_username: info['username'])
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
