platform :ios, '15.0'
use_frameworks!

target 'AppEShop' do
  # Firebase
  pod 'FirebaseFirestore'
  pod 'FirebaseFirestoreSwift'
  
  # Networking
  pod 'Alamofire'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      
      # Fix for BoringSSL on Apple Silicon
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphoneos*]'] = ''
    end
  end
end
