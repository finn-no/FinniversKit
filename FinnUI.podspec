Pod::Spec.new do |s|
  s.name         = 'FinnUI'
  s.version      = '15.0.1'
  s.summary      = "FINN's iOS UI Features"
  s.author       = 'FINN.no'
  s.homepage     = 'https://schibsted.frontify.com/d/oCLrx0cypXJM/design-system'
  s.social_media_url   = 'https://twitter.com/FINN_tech'
  s.description  = <<-DESC
  FinnUI is the iOS native implementation of some of the UI in the FINN.no app.
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

  s.platform      = :ios, '11.2'
  s.swift_version = '5.0'
  s.source        = { :git => "https://github.com/finn-no/FinniversKit.git", :tag => "finnui-#{s.version}" }
  s.requires_arc  = true

  s.source_files = 'FinnUI/Sources/*.{h,m,swift}', 'FinnUI/Sources/**/*.{h,m,swift}', 'FinnUI/Sources/**/**/*.{h,m,swift}'
  s.resources    = 'FinnUI/Sources/Resources/Fonts/*.ttf', 'FinnUI/Sources/Resources/*.xcassets', 'FinnUI/Sources/Resources/Sounds/*.{mp3,wav,sf2}'
  s.resource_bundles = {
      'FinnUI' => ['FinnUI/Sources/Resources/*.xcassets', 'FinnUI/Sources/Resources/Fonts/*.ttf', 'FinnUI/Sources/Resources/Sounds/*.{mp3,wav,sf2}']
  }
  s.dependency "FinniversKit"
  s.frameworks = 'Foundation', 'UIKit', 'FinniversKit'
  s.weak_frameworks = 'SwiftUI'
end
