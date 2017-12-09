
Pod::Spec.new do |s|

  s.name         = "LPThumbnailView"
  s.version      = "0.1.0"
  s.summary      = "A thumbnail view for iOS."

  s.description  = <<-DESC
  A thumbnail view for iOS. 
                   DESC

  #s.homepage     = ""
  #s.screenshots  = ""

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Luis Padron" => "heyluispadron@gmail.com" }
  s.social_media_url   = "https://luispadron.com"

  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/luispadron/LPThumbnailView.git", :tag => "v#{s.version}" }

  s.source_files  = "LPThumbnailView", "LPThumbnailView/**/*.{h,m}"
end

