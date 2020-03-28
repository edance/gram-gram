module PhotosHelper
  def lazy_image_tag(url, opts)
    opts[:class] = "#{opts[:class]} img-lazy"
    tag.img(opts.merge(data: { src: url }))
  end
end
