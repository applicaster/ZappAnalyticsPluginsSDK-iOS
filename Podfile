# Uncomment the next line to define a global platform for your project
source 'git@github.com:CocoaPods/Specs.git'
source 'git@github.com:applicaster/CocoaPods.git'
source 'git@github.com:applicaster/CocoaPods-Private.git'
use_frameworks!

target 'ZappAnalyticsPluginsSDK' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  platform :ios, '10.0'

  # Pods for ZappAnalyticsPluginsSDK
  pod 'ZappPlugins', :path => 'Submodules/ZappPlugins/ZappPlugins.podspec'
  pod 'Toaster', :git => 'https://github.com/devxoul/Toaster.git', :tag => '2.2.0'

  target 'ZappAnalyticsPluginsSDKTests' do
    # Pods for testing
  end

end

target 'ZappAnalyticsPluginsSDKTvOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  platform :tvos, '10.0'

  pod 'ZappPlugins', :path => 'Submodules/ZappPlugins/ZappPlugins.podspec'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
