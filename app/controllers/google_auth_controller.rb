class GoogleAuthController < ApplicationController
  before_action :verify_g_csrf_token
  skip_before_action :verify_authenticity_token

  BASE_URL = 'https://oauth2.googleapis.com'.freeze

  def callback
    res = client.get('tokeninfo', id_token: params.require(:credential))
    @user = find_or_create_user(res.body)
    sign_in @user

    redirect_to root_path
  end

  private

  def verify_g_csrf_token
    return if cookies[:g_csrf_token].present? &&
              cookies[:g_csrf_token] == params.require(:g_csrf_token)

    flash[:error] = 'You could not be authenticated'

    redirect_to root_path
  end

  def client
    Faraday.new(url: BASE_URL) do |f|
      f.response :json

      f.adapter Faraday.default_adapter
    end
  end

  def find_or_create_user(attrs)
    email = attrs['email']
    user = User.find_by_email(email)
    return user if user.present?

    User.create(
      email: email,
      name: "#{attrs['given_name']} #{attrs['family_name']}",
      password: SecureRandom.urlsafe_base64(50)
    )
  end
end
