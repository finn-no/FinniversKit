Pod::Spec.new do |s|
  s.name         = 'FinniversKit'
  s.version      = '103.0.0'
  s.summary      = "FINN's iOS Components"
  s.author       = 'FINN.no'
  s.homepage     = 'https://schibsted.frontify.com/d/oCLrx0cypXJM/design-system'
  s.social_media_url   = 'https://twitter.com/FINN_tech'
  s.description  = <<-DESC
  FinniversKit is the iOS native implementation of FINN's design system.
                   DESC

  s.license      = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
  }

  s.platform      = :ios, '14.0'
  s.swift_version = '5.0'
  s.source        = { :git => "https://github.com/finn-no/FinniversKit.git", :tag => s.version }
  s.requires_arc  = true

  s.source_files = 'FinniversKit/Sources/*.{h,m,swift}', 'FinniversKit/Sources/**/*.{h,m,swift}', 'FinniversKit/Sources/**/**/*.{h,m,swift}'
  s.resources    = 'FinniversKit/Sources/Assets/Fonts/*.ttf', 'FinniversKit/Sources/Assets/*.xcassets', 'FinniversKit/Sources/Assets/Sounds/*.{mp3,wav,sf2}'
  s.resource_bundles = {
      'FinniversKit' => ['FinniversKit/Sources/Assets/*.xcassets', 'FinniversKit/Sources/Assets/Fonts/*.ttf', 'FinniversKit/Sources/Assets/Sounds/*.{mp3,wav,sf2}']
  }
  s.frameworks = 'Foundation', 'UIKit'
  s.weak_frameworks = 'SwiftUI'
  s.subspec 'DNA' do |sp|
    sp.source_files  = 'FinniversKit/Sources/*.{h,m,swift}', 'FinniversKit/Sources/DNA/*.{h,m,swift}', 'FinniversKit/Sources/DNA/**/*.{h,m,swift}', 'FinniversKit/Sources/DNA/**/**/*.{h,m,swift}', 'FinniversKit/Sources/Assets/*.{h,m,swift}', 'FinniversKit/Sources/Assets/**/*.{h,m,swift}', 'FinniversKit/Sources/Assets/**/**/*.{h,m,swift}'
    sp.resource_bundles = {
        'FinniversKitDNA' => ['FinniversKit/Sources/Assets/*.xcassets', 'FinniversKit/Sources/Assets/Fonts/*.ttf']
    }
    sp.requires_arc = true
    sp.frameworks = 'Foundation', 'UIKit'
  end
end
