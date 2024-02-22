Pod::Spec.new do |spec|
  spec.name          = "SwiftUI-Utils"
  spec.version       = "1.0.6"
  spec.summary       = "SwiftUI Utils library"
  spec.description   = "SwiftUI Utils is a library that contains several helpful components and extension methods to help you build the best SwiftUI apps."
  spec.homepage      = "https://github.com/mirego/swiftui-utils"
  spec.license       = { :type => "MIT", :file => "LICENSE.md" }
  spec.author        = { "Hugo Lefrancois" => "hlefrancois@mirego.com" }
  spec.source        = { :git => "https://github.com/mirego/swiftui-utils.git", :tag => spec.version }
  spec.source_files  = ["Sources/SwiftUI-Utils/**/*.swift"]
  spec.static_framework = true
  spec.ios.deployment_target = "15.0"
  spec.swift_versions = "5.0"
end
