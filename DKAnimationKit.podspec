Pod::Spec.new do |s|
  s.name         = "DKAnimationKit"
  s.version      = "0.1.1"
  s.summary      = "Chainable Animation in Swift"

  s.description  = <<-DESC
                   DKAnimationKit is rewritten for JHChainableAnimations and provide you a more convience approach to deal with Animation in swift, if your app is developed using Objective-C, you should use JHChainableAnimations instead.
                   DESC

  s.homepage     = "https://github.com/Draveness/DKAnimationKit"

  s.license      = "MIT"
  s.author             = { "Draveness" => "stark.draven@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Draveness/DKAnimationKit.git", :tag => s.version }

  s.source_files  = "Classes/*.swift"
end
