Pod::Spec.new do |s|
  s.name         = "DKAnimationKit"
  s.version      = "0.0.1"
  s.summary      = "Chainable Animation in Swift"

  s.description  = <<-DESC
                   A longer description of DKAnimationKit in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/Draveness/DKAnimationKit"

  s.license      = "MIT"
  s.author             = { "Draveness" => "stark.draven@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Draveness/DKAnimationKit.git", :tag => s.version }

  s.source_files  = "Classes/*.swift"
end
