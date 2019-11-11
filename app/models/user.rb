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
  CAROUSEL_CHILDREN_FIELDS = (MEDIA_FIELDS - %w[caption]).freeze

  MEDIA_TYPE_IMAGE = 'IMAGE'
  MEDIA_TYPE_CAROUSEL = 'CAROUSEL_ALBUM'

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

  def instagram_photos
    _media = media
    return unless _media['error'].nil?

    media_count = _media['data'].size
    ig_photos = []
    media['data'].each_with_index do |m, i|
      case m['media_type']
      when MEDIA_TYPE_IMAGE
        ig_photos.push(m)
      when MEDIA_TYPE_CAROUSEL
        ig_photos += photos_from_carousel(m['id'])
      end

      broadcast_photo_count(media_count, i + 1)
    end

    ig_photos
  end

  private

  def instagram_client
    @instagram_client ||= Faraday.new(url: INSTAGRAM_BASE_URL) do |f|
      f.response :json

      f.adapter Faraday.default_adapter
    end
  end

  def photos_from_carousel(media_id)
    media = instagram_client.get(
      "#{media_id}/children",
      fields: CAROUSEL_CHILDREN_FIELDS.join(','),
      access_token: instagram_access_token
    ).body

    media['data'].select { |m| m['media_type'] == MEDIA_TYPE_IMAGE }
  end

  def broadcast_photo_count(media_count, processed_media_count)
    ActionCable.server.broadcast(
      "photos_for_#{id}",
      total_media_count: media_count,
      processed_media_count: processed_media_count
    )
  end
end
