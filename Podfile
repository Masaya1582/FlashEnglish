# Uncomment the next line to define a global platform for your project
  platform :ios, '16.0'

target 'FlashEnglish' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FlashEnglish
    pod 'SwiftGen', '~> 6.0'
    pod 'lottie-ios'
    pod 'Google-Mobile-Ads-SDK'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'
    pod 'Firebase/Crashlytics'
    pod 'Firebase/Analytics'
    pod 'Firebase/Performance'

end

# Post-install hook to disable code signing for frameworks installed by CocoaPods
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
    end
  end
end
