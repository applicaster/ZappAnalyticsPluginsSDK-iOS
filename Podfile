# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
source 'git@github.com:CocoaPods/Specs.git'
source 'git@github.com:applicaster/CocoaPods.git'
source 'git@github.com:applicaster/CocoaPods-Private.git'

target 'ZappAnalyticsPluginsSDK' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ZappAnalyticsPluginsSDK
  pod 'ZappPlugins', :path => 'Submodules/ZappPlugins/ZappPlugins-Dev.podspec'
  pod 'Toaster'

  target 'ZappAnalyticsPluginsSDKTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
    end
end
