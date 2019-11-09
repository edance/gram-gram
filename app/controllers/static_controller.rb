# frozen_string_literal: true

class StaticController < ApplicationController
  before_action :redirect_users, only: [:home]

  private

  def redirect_users
    return if current_user.nil?

    redirect_to photos_path
  end
end
