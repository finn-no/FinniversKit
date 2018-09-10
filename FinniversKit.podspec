Pod::Spec.new do |s|
  s.name         = 'FinniversKit'
  s.version      = '0.5.0'
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

  s.platform      = :ios, '9.0'
  s.swift_version = '4.0'
  s.source        = { :git => "https://github.com/finn-no/FinniversKit.git", :tag => s.version }
  s.requires_arc  = true

  s.source_files = 'Sources/*.{h,m,swift}', 'Sources/**/*.{h,m,swift}', 'Sources/**/**/*.{h,m,swift}'
  s.resources    = 'Sources/Resources/Fonts/*.ttf', 'Sources/Resources/*.xcassets'
  s.resource_bundles = {
      'FinniversKit' => ['Sources/Resources/*.xcassets', 'Sources/Resources/Fonts/*.ttf']
    }
  s.exclude_files = 'Demo*.swift', '*Demo*.swift', 'Sources/**/**/Demo/*swift', 'Sources/**/**/**/Demo/*swift', 'Sources/Components/**/*DemoView.swift', 'Sources/Components/**/Demo/', '*DemoView.swift', 'Sources/Components/**/**/Demo/*.swift', '*Helpers.swift', 'Sources/DNA/**/Demo/*.swift'
  s.frameworks = 'Foundation', 'UIKit'
  s.subspec 'DNA' do |sp|
    sp.source_files  = 'Sources/DNA/*.{h,m,swift}', 'Sources/DNA/**/*.{h,m,swift}', 'Sources/DNA/**/**/*.{h,m,swift}'
    sp.resources     = 'Sources/Resources/*.{xcassets,ttf}', 'Sources/Resources/**/*.{xcassets,ttf}', 'Sources/Resources/**/**/*.{xcassets,ttf}'
    sp.requires_arc = true
  end
end
