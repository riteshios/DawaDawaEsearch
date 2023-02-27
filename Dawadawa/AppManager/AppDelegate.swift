//  AppDelegate.swift
//  Dawadawa
//  Created by Ritesh Gupta on 09/06/22.

import UIKit
import IQKeyboardManagerSwift
import DropDown
import Firebase
import AlamofireImage
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import FirebaseAuth
import FirebaseAnalytics
import GoogleSignIn
import GoogleMaps
import GooglePlaces

//1059152771536-3kh5ndu9s3l9620pipf115lgq947feng.apps.googleusercontent.com

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let navigator = Navigator()
    let gcmMessageIDKey = "gcmMessageIDKey"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        window = UIWindow(frame: UIScreen.main.bounds)
        
        sleep(3)
        self.setLanguage()
        
        GMSServices.provideAPIKey("AIzaSyAI8WH6BIqmnjlisvSceaD3zYafhCSW2e4")
        GMSPlacesClient.provideAPIKey("AIzaSyBTnohiHM33y3BMxvAP_SoEnG9Vfm6-9Pg")
        FirebaseApp.configure()
        //        Push Notification
        setUpNotification()
        self.registerFCM(application: application)
        if #available(iOS 10.0, *) {
            
            // For iOS 10 display notification (sent via APNS)
            
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                
                options: authOptions,
                completionHandler: {_, _ in })
            
        } else {
            
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
        
        //        FirebaseApp.configure()
        
        application.registerForRemoteNotifications()
        
        var isUniversalLinkClick: Bool = false
        if ((launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary]) != nil) {
            let activityDictionary = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] ?? [AnyHashable: Any]()
            let activity = activityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity ?? NSUserActivity()
            if activity != nil {
                isUniversalLinkClick = true
            }
        }
        if isUniversalLinkClick {
            // app opened via clicking a universal link.
            let window = UIApplication.shared.windows.first
            let storybaord = UIStoryboard(name: "Home", bundle: nil)
            window?.rootViewController  = storybaord.instantiateViewController(withIdentifier: "DetailScreenVC")
            
            window?.makeKeyAndVisible()
        } else {
            // set the initial viewcontroller
            let window = UIApplication.shared.windows.first
            let storybaord = UIStoryboard(name: "Home", bundle: nil)
            window?.rootViewController  = storybaord.instantiateViewController(withIdentifier: "BuyPlanVC")
            window?.makeKeyAndVisible()
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func setLanguage(){
        if UserDefaults.standard.object(forKey: "Language") != nil && UserDefaults.standard.object(forKey: "Language") as! String == "ar"
        {
            UserDefaults.standard.set("ar", forKey: "Language")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else
        {
            UserDefaults.standard.set("en", forKey: "Language")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        //        let current_localization = SharedClass.fetchString(forKey: kLanguage)
        //        if current_localization == kArabic{
        //            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        //            //            setupMenuScreenRight()
        //            Localize.setCurrentLanguage("ar")
        //        }
        //        else if current_localization == kEnglish{
        //            //            setupMenuScreen()
        //            Localize.setCurrentLanguage("en")
        //            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        //
        //            //        NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateLanguage), object: nil)
        //        }
    }
    
    
    func makeRootViewController(){
        guard  let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC else {return}
        let navC = UINavigationController(rootViewController: controller)
        navC.navigationBar.isHidden = true
        navC.navigationBar.barStyle = .black
        UIApplication.shared.windows.first?.rootViewController = navC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
  
    func moveToLoginScreen(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier:"WelcomeScreenVC") as! WelcomeScreenVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func moveTOLoginSubscriptionPlanScreen(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier:"LoginSubscriptionPlanVC") as! LoginSubscriptionPlanVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func dropDown(dataSource:[String] , text:UIView , completion: @escaping ( _ index: Int , _ item: String) -> ()) -> Void {
        let dropDown = DropDown()
        dropDown.anchorView = text
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = UIColor.white
        dropDown.textColor = UIColor.init(hexString: "#1572A1")
        dropDown.width = text.frame.size.width
        dropDown.direction = .bottom
        dropDown.selectionBackgroundColor = UIColor.white
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .onTap
        dropDown.show()
        dropDown.selectionAction = {(index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            completion(index,item)
        }
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        // 1
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                  let window = UIApplication.shared.windows.first
                  
                  let storybaord = UIStoryboard(name: "Home", bundle: nil)
                  window?.rootViewController  = storybaord.instantiateViewController(withIdentifier: "DetailScreenVC")
                  window?.makeKeyAndVisible()
                  
                  return false
              }
        
        // 2
        //      if let computer = ItemHandler.sharedInstance.items.filter({ $0.path == components.path}).first {
        //        presentDetailViewController(computer)
        //        return true
        //      }
        
        // 3 rw-universal-links-final.herokuapp.com
        if let webpageUrl = URL(string: "https://demo4esl.com/dawadawa/") {
            application.open(webpageUrl)
            return false
        }
        
        return false
    }
    
}

// Push Notification

@available(iOS 10, *)

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let firebase = fcmToken
        kSharedUserDefaults.setDeviceToken(deviceToken: firebase)
        print("Firebase registration token: \(String(describing: fcmToken))")
    }
    
    func clickOnNotificationBackGround(userInfo: NSDictionary) {
        guard let dict = userInfo["aps"]  as? [String: Any], let _ = dict ["alert"] as? NSDictionary else {
            print("Notification Parsing Error")
            return
        }
    }
    
    // Receive displayed notifications for iOS 10 devices.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        completionHandler([[.alert, .sound]])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        //
        
        let window = UIApplication.shared.windows.first
        let storybaord = UIStoryboard(name: "Home", bundle: nil)
        window?.rootViewController  = storybaord.instantiateViewController(withIdentifier: "NotifiactionViewController")
        window?.makeKeyAndVisible()
        
        print("userInfo------",userInfo)
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let body = alert["body"] as? NSString {
                    print("body--", body)
                }
                
                else if let title = alert["title"] as? NSString {
                    print("body--", title)
                }
            }
        }
        
        completionHandler()
    }
    
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            // 1. Check if permission granted
            
            guard granted else { return }
            
            // 2. Attempt registration for remote notifications on the main thread
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // 1. Convert device token to string
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        
        // 2. Print device token to use for PNs payloads
        
        print("Device Token: \(token)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        // 1. Print out error if PNs registration not successful
        
        print("Failed to register for remote notifications with error: \(error)")
        
    }
    
    
    func registerFCM(application : UIApplication)  {
        
        //        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in})
            application.registerForRemoteNotifications()
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
        } else {
            
            let settings: UIUserNotificationSettings = UIUserNotificationSettings.init(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        let fcmToken = String()
        if(fcmToken != ""){
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    
    
    func setUpNotification()  {
        
        //Local Notification
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { (granted, error) in
            
        }
    }
}

extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        if fcmToken != ""{
            
            //            fireBasetoken = fcmToken!
            kSharedUserDefaults.setDeviceToken(deviceToken: fcmToken!)
            
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print("Received data message: \(remoteMessage.description)")
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("InstanceID token: \(fcmToken)")
    }
}

// Handling Universal Link
extension AppDelegate {
    
    //    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    //        print("Continue User Activity called: ")
    //
    //        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
    //            let url = userActivity.webpageURL!
    //            print(url.absoluteString)
    //
    //            //handle url and open whatever page you want to open.
    //
    //            let window = UIApplication.shared.windows.first
    //
    //            let storybaord = UIStoryboard(name: "Home", bundle: nil)
    //
    //            window?.rootViewController  = storybaord.instantiateViewController(withIdentifier: "DetailScreenVC")
    //
    //            window?.makeKeyAndVisible()
    //
    //        }
    //        return true
    //    }
    
    
    //      func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    //
    //        guard let url = userActivity.webpageURL else{return false}
    //
    //        guard let vc = navigator.getDestination(for: url) else{
    //            application.open(url)
    //
    //            return false
    //        }
    //        window?.rootViewController = vc
    //        window?.makeKeyAndVisible()
    //        return true
    //    }
    
}


