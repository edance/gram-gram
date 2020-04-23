module AmpHelper
  def amp_css(path)
    "<style amp-custom>#{inline_file(path)}</style>".html_safe
  end

  private

  def inline_file(path)
    assets = Rails.application.assets
    if assets
      asset = assets.find_asset(path)
      return '' unless asset

      asset.source
    else
      File.read(File.join(Rails.root, 'public', asset_path(path)))
    end
  end
end
