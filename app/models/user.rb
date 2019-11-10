# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  has_many :photos
  has_many :recipients
  has_many :postcards, through: :photos

  INSTAGRAM_BASE_URL = 'https://graph.instagram.com'
  USER_FIELDS = %w[id username media_count account_type].freeze
  MEDIA_FIELDS = %w[caption id media_type media_url permalink thumbnail_url
                    timestamp username].freeze

  def user_information
    instagram_client.get(
      'me',
      fields: USER_FIELDS.join(','),
      access_token: instagram_access_token
    ).body
  end

  def media
    instagram_client.get(
      "#{instagram_uid}/media",
      fields: MEDIA_FIELDS.join(','),
      access_token: instagram_access_token
    ).body
  end

  private

  def instagram_client
    @instagram_client ||= Faraday.new(url: INSTAGRAM_BASE_URL) do |f|
      f.response :json

      f.adapter Faraday.default_adapter
    end
  end
end
