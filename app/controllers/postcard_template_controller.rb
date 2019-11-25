class PostcardTemplateController < ApplicationController
  layout false

  def front
    @photo_url = 'https://www.fillmurray.com/150/150.jpg'
    @caption = 'This is an example'
  end
end
