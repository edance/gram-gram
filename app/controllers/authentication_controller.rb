class AuthenticationController < ApplicationController
  def authorize
    base_url = 'https://api.instagram.com/oauth/authorize'
    query = {
      app_id: ENV['INSTAGRAM_ID'],
      redirect_uri: 'https://gramgram.app/auth/instagram/callback',
      scope: 'user_profile,user_media',
      response_type: 'code'
    }
    redirect_to "#{base_url}?#{query.to_query}"
  end

  def callback; end
end
