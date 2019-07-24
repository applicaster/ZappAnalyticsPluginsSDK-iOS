Pod::Spec.new do |s|
  s.name  = "__framework_name__"
  s.version = '__version__'
  s.platform  = :ios, :tvos
  s.ios.deployment_target = "__ios_platform_version__"
  s.tvos.deployment_target = "__tvos_platform_version__"
  s.summary = "__framework_name__"
  s.description = "__framework_name__ container."
  s.homepage  = "https://github.com/applicaster/__framework_name__-iOS"
  s.license = 'CMPS'
  s.author = { "cmps" => "Applicaster LTD." }
  s.source  = { :git => "git@github.com:applicaster/__framework_name__-iOS.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.static_framework = false

  s.source_files  = '__framework_name__/**/*.{h,m,swift}'
  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                'ENABLE_BITCODE' => 'YES',
                'SWIFT_VERSION' => '__swift_version__',
                'OTHER_CFLAGS'  => '-fembed-bitcode'
              }

  s.dependency 'ZappPlugins'
  s.ios.dependency 'Toaster', '= 2.2.0'
end
