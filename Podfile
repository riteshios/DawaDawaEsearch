# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Dawadawa' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Dawadawa
  
  pod 'Alamofire','~> 4.0'
  pod 'SDWebImage', '~> 4.0'
  pod 'AlamofireImage'
  pod 'IQKeyboardManagerSwift'
  pod 'GoogleMaps'
  pod 'GoogleSignIn'
  pod 'GooglePlaces'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'SVProgressHUD'
  pod 'SwiftyGif'
  pod 'SKFloatingTextField'
  pod 'SwiftMessages'
  pod 'STTabbar'
  pod 'DropDown'
  pod 'SwiftyJSON'
  pod 'RangeSeekSlider'
  pod 'Cosmos', '~> 23.0'
  pod 'Stripe'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseAnalytics'
  pod 'FirebaseMessaging'
  

end



post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings["DEVELOPMENT_TEAM"] = "ND9V4FHD99"
         end
    end
  end
end
