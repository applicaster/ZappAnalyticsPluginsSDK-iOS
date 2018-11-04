Pod::Spec.new do |s|
  s.name  = "ZappAnalyticsPluginsSDK"
  s.version = '5.0.6'
  s.platform  = :ios, '9.0'
  s.summary = "ZappAnalyticsPluginsSDK"
  s.description = "ZappAnalyticsPluginsSDK container."
  s.homepage  = "https://github.com/applicaster/ZappAnalyticsPluginsSDK-iOS"
  s.license = 'CMPS'
  s.author = { "cmps" => "Applicaster LTD." }
  s.source  = { :git => "git@github.com:applicaster/ZappAnalyticsPluginsSDK-iOS.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.static_framework = true

  s.public_header_files = 'ZappAnalyticsPluginsSDK/**/*.h'
  s.source_files  = 'ZappAnalyticsPluginsSDK/**/*.{h,m,swift}'
  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                'ENABLE_BITCODE' => 'YES',
                'SWIFT_VERSION' => '4.1',
                'OTHER_CFLAGS'  => '-fembed-bitcode'
              }

  s.dependency 'ZappPlugins', '~> 6.0.0'
  s.dependency 'Toaster'
end
