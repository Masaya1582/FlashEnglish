# Uncomment the next line to define a global platform for your project
  platform :ios, '16.0'

target 'FlashEnglish' do
  use_frameworks!
  inhibit_all_warnings!
    # Application
    pod 'SwiftGen', '~> 6.0'
    pod 'lottie-ios'
    pod 'Google-Mobile-Ads-SDK'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'
    pod 'Firebase/Crashlytics'
    pod 'Firebase/Analytics'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end