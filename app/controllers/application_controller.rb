class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by_id(cookies.encrypted[:user_id])
  end

  def redirect_guests
    return if current_user.present?

    redirect_to root_path
  end
end
