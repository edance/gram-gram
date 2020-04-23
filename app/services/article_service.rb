class ArticleService
  attr_accessor :preview

  def initialize(preview: false)
    @preview = preview
  end

  def fetch_article(slug)
    client.entries(
      'fields.slug' => slug,
      content_type: 'post',
      limit: 1
    ).first
  end

  def client
    @client ||= preview ? preview_client : base_client
  end

  private

  def base_client
    Contentful::Client.new(
      space: ENV['CONTENTFUL_SPACE'],
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN']
    )
  end

  def preview_client
    Contentful::Client.new(
      space: ENV['CONTENTFUL_SPACE'],
      access_token: ENV['CONTENTFUL_PREVIEW_TOKEN'],
      api_url: 'preview.contentful.com'
    )
  end
end
