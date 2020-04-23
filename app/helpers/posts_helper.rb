class RenderAmp < Redcarpet::Render::HTML
  def image(link, _title, alt_text)
    %(<amp-img alt="#{alt_text}" src="#{link}" class="contain" width="300"
      height="200" layout="responsive" />)
  end
end

module PostsHelper
  def title
    @post.title
  end

  def author_and_published
    "By Evan, on #{@post.sys[:updated_at].strftime('%b %d, %Y')}"
  end

  def body
    renderer.render(@post.body)
  end

  def renderer
    Redcarpet::Markdown.new(RenderAmp, autolink: true)
  end
end
