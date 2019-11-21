module PhotosHelper
  def caption(photo)
    photo.ig_caption
  end

  def new?(photo)
    photo.ig_timestamp > 2.weeks.ago
  end
end
