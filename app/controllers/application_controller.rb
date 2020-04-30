class ApplicationController < ActionController::Base
  def not_found
    raise(ActionController::RoutingError, 'Not Found')
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(_)
    new_user_session_path
  end
end
