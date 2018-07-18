Pod::Spec.new do |s|
  s.name  = "ZappAnalyticsPluginsSDK"
  s.version = '__version__'
  s.platform  = :ios, '9.0'
  s.summary = "ZappAnalyticsPluginsSDK"
  s.description = "ZappAnalyticsPluginsSDK container."
  s.homepage  = "https://github.com/applicaster/ZappAnalyticsPluginsSDK-iOS"
  s.license = 'CMPS'
	s.author = "Applicaster LTD."
	s.source = {
      "http" => "__source_url__"
  }

  s.static_framework = true
  s.requires_arc = true

  s.vendored_frameworks = 'ZappAnalyticsPluginsSDK.framework'
  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                'ENABLE_BITCODE' => 'YES',
                'SWIFT_VERSION' => '4.1',
                'OTHER_CFLAGS'  => '-fembed-bitcode'
              }

  s.dependency 'ZappPlugins'
end
