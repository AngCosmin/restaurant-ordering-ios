# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'RewardMe' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RewardMe
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'FirebaseUI/Google'
  pod 'Firebase/Database'
  pod 'GoogleSignIn'
  pod 'SVProgressHUD'
  pod 'ChameleonFramework'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'Cosmos'
  pod 'SideMenu'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
      end
  end
end
