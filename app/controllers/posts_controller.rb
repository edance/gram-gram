class PostsController < ApplicationController
  layout 'amp'

  def show
    @post = article_service.fetch_article(params[:slug])
    return not_found if @post.nil?

    @next_post = article_service.next_article(@post)
  end

  private

  def article_service
    @article_service ||= ArticleService.new(preview: params[:preview])
  end
end
