class PostsController < ApplicationController
  layout 'amp'

  def show
    @post = ArticleService
            .new(preview: params[:preview])
            .fetch_article(params[:slug])
  end
end
