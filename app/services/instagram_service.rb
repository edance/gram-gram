class InstagramService
  include ::NewRelic::Agent::MethodTracer

  add_method_tracer :user_information, 'Instagram/user_information'
  add_method_tracer :media, 'Instagram/media'

  attr_accessor :user

  INSTAGRAM_GRAPH_URL = 'https://graph.instagram.com'.freeze
  INSTAGRAM_BASE_URL = 'https://www.instagram.com'.freeze
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
    body = graph_client.get(
      'me',
      fields: USER_FIELDS.join(','),
      access_token: user.instagram_access_token
    ).body
    body.merge(hidden_information(body['username']))
  end

  def media
    graph_client.get(
      "#{user.instagram_uid}/media",
      fields: MEDIA_FIELDS.join(','),
      access_token: user.instagram_access_token
    ).body
  end

  def photos
    media_resp = media
    return [] unless media_resp['error'].nil?

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

  def graph_client
    client(INSTAGRAM_GRAPH_URL)
  end

  def base_client
    client(INSTAGRAM_BASE_URL)
  end

  def client(url = INSTAGRAM_GRAPH_URL)
    Faraday.new(url: url) do |f|
      f.response :json

      f.adapter Faraday.default_adapter
    end
  end

  def hidden_information(username)
    body = base_client.get("/#{username}/\?__a\=1").body
    body.try(:[], 'graphql').try(:[], 'user') || {}
  end

  def photos_from_carousel(media_id)
    media_resp = graph_client.get(
      "#{media_id}/children",
      fields: CAROUSEL_CHILDREN_FIELDS.join(','),
      access_token: user.instagram_access_token
    ).body

    media_resp['data'].select { |m| m['media_type'] == MEDIA_TYPE_IMAGE }
  end
end
