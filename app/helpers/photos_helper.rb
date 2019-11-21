module PhotosHelper
  def new?(photo)
    photo.ig_timestamp > 2.weeks.ago
  end
end
