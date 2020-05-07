class GoogleAuthController < ApplicationController
  BASE_URL = 'https://oauth2.googleapis.com'.freeze

  def callback
    res = client.get('tokeninfo', id_token: params.require(:credential))
    @user = find_or_create_user(res.body)
    sign_in @user

    redirect_to root_path
  end

  private

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
