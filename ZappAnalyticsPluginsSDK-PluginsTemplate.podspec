Pod::Spec.new do |s|
  s.name  = "__SDK_NAME__"
  s.version = '__version__'
  s.platform  = :ios, '9.0'
  s.summary = "__SDK_NAME__"
  s.description = "__SDK_NAME__ container."
  s.homepage  = "https://github.com/applicaster/__SDK_NAME__-iOS"
  s.license = 'CMPS'
	s.author = "Applicaster LTD."
	s.source = {
      "http" => "__source_url__"
  }

  s.static_framework = true
  s.requires_arc = true
  
  s.vendored_frameworks = '__SDK_NAME__.framework'
  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                'ENABLE_BITCODE' => 'YES',
                'SWIFT_VERSION' => '4.1',
                'OTHER_CFLAGS'  => '-fembed-bitcode'
              }

  s.dependency 'ZappPlugins'
  s.dependency 'Toaster'

end
