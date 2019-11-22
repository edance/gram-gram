class InstagramService
  attr_accessor :user

  INSTAGRAM_BASE_URL = 'https://graph.instagram.com'.freeze
  USER_FIELDS = %w[id username media_count account_type].freeze
  MEDIA_FIELDS = %w[caption id media_type media_url permalink thumbnail_url
                    timestamp username].freeze
  CAROUSEL_CHILDREN_FIELDS = (MEDIA_FIELDS - %w[caption]).freeze
  MEDIA_TYPE_IMAGE = 'IMAGE'.freeze
  MEDIA_TYPE_CAROUSEL = 'CAROUSEL_ALBUM'.freeze

  def initialize(user)
    @user = user
  end

  def user_information
    client.get(
      'me',
      fields: USER_FIELDS.join(','),
      access_token: user.instagram_access_token
    ).body
  end

  def media
    client.get(
      "#{user.instagram_uid}/media",
      fields: MEDIA_FIELDS.join(','),
      access_token: user.instagram_access_token
    ).body
  end

  def photos
    media_resp = media
    return unless media_resp['error'].nil?

    media_resp['data'].map do |m|
      case m['media_type']
      when MEDIA_TYPE_IMAGE
        m
      when MEDIA_TYPE_CAROUSEL
        photos_from_carousel(m['id'])
      end
    end.flatten.compact
  end

  private

  def client
    @client ||= Faraday.new(url: INSTAGRAM_BASE_URL) do |f|
      f.response :json

      f.adapter Faraday.default_adapter
    end
  end

  def photos_from_carousel(media_id)
    media_resp = client.get(
      "#{media_id}/children",
      fields: CAROUSEL_CHILDREN_FIELDS.join(','),
      access_token: user.instagram_access_token
    ).body

    media_resp['data'].select { |m| m['media_type'] == MEDIA_TYPE_IMAGE }
  end
end
