Pod::Spec.new do |spec|
  spec.name         = "SwiftDisks"
  spec.version      = "0.0.8"
  spec.summary      = "Disk Utility functions in Swift"
  spec.description  = <<-DESC
  Disk Utility functions for macOS available in Swift
                   DESC
  spec.homepage     = "https://github.com/128keaton/SwiftDisks"
  spec.license      = "MIT"
  spec.author       = { "Keaton Burleson" => "keaton.burleson@me.com" }
  spec.platform     = :osx
  spec.osx.deployment_target = "10.13"
  spec.swift_versions = "5.0"
  spec.source       = { :git => "https://github.com/128keaton/SwiftDisks.git", :tag => "#{spec.version}" }
  spec.source_files  = "SwiftDisks", "SwiftDisks/**/*.{h,m,swift}"
  spec.exclude_files = "SwiftDisksDemo"
  spec.requires_arc = true
  spec.resource_bundles = {
    'SwiftDisks' => ['SwiftDisks/Scripts/**/*.sh']
  }
  
end
