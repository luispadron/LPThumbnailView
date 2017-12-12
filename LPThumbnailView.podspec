
Pod::Spec.new do |s|

  s.name         = "LPThumbnailView"
  s.version      = "1.1.0"
  s.summary      = "An image thumbnail view for iOS."

  s.description  = <<-DESC
  A thumbnail view for iOS to give context to multiple images/videos using thumbnails and counter.
                   DESC

  s.homepage     = "https://github.com/luispadron/LPThumbnailView"
  s.screenshots  = "https://raw.githubusercontent.com/luispadron/LPThumbnailView/master/.github/thumbnail.png"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Luis Padron" => "heyluispadron@gmail.com" }
  s.social_media_url   = "https://luispadron.com"

  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/luispadron/LPThumbnailView.git", :tag => "v#{s.version}" }

  s.source_files  = "LPThumbnailView", "LPThumbnailView/**/*.{h,m}"
end

