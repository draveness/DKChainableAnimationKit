Pod::Spec.new do |s|
  s.name         = "DKChainableAnimationKit"
  s.version      = "1.6.0"
  s.summary      = "Chainable Animation in Swift"

  s.description  = <<-DESC
                   DKChainableAnimationKit is rewritten for JHChainableAnimations and provide you a more convience approach to deal with Animation in swift, if your app is developed using Objective-C, you should use JHChainableAnimations instead.
                   DESC

  s.homepage     = "https://github.com/Draveness/DKChainableAnimationKit"

  s.license      = "MIT"
  s.author             = { "Draveness" => "stark.draven@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Draveness/DKChainableAnimationKit.git", :tag => s.version }

  s.source_files  = "DKChainableAnimationKit/Classes/*.swift"
end
