module ApplicationHelper
  CLOUDINARY_FETCH = 'https://res.cloudinary.com/gramgram/image/fetch/c_scale,f_auto,w_250/'.freeze

  def copyright_year
    DateTime.now.year
  end

  def cl_image_tag(url, opts)
    url = ERB::Util.url_encode(url)
    image_tag("#{CLOUDINARY_FETCH}#{url}", opts)
  end
end
