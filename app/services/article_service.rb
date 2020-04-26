class ArticleService
  attr_accessor :preview

  def initialize(preview: false)
    @preview = preview
  end

  def all_articles
    client.entries(content_type: 'post')
  end

  def fetch_article(slug)
    client.entries(
      'fields.slug' => slug,
      content_type: 'post',
      limit: 1
    ).first
  end

  def next_article(article)
    client.entries(
      # Articles created after the current article
      'sys.createdAt[gt]': article.sys[:created_at].to_s,
      # Skip the current article
      'sys.id[nin]': article.id,
      content_type: 'post',
      limit: 1,
      order: 'sys.createdAt'
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
