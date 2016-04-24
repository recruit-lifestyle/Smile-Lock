Pod::Spec.new do |s|
  s.name         = "SmileLock"
  s.version      = "0.0.1"
  s.summary      = "A library for make a beautiful Passcode Lock View."
  s.description  = <<-DESC
                   1. Create a beautiful passcode lock view simply.
                   2. Passcode input completed delegate callback.
                   3. Customize UI.
                   DESC

  s.homepage     = "https://github.com/liu044100/Smile-Lock"
  s.screenshots  = "https://raw.githubusercontent.com/liu044100/Smile-Lock/master/SmileLock-Example/demo_gif/demo.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { 'Rain' => 'liu044100@gmail.com' }
  s.social_media_url   = "https://dribbble.com/yuchenliu"


  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/liu044100/Smile-Lock.git", :tag => s.version.to_s}
  s.source_files  = 'SmileLock/Classes/*.{swift}'
  s.resources = ['SmileLock/Assets/*.xib']
  s.frameworks = 'UIKit'

end
