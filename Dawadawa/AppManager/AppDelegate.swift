//
//  AppDelegate.swift
//  Dawadawa
//
//  Created by Alekh Verma on 09/06/22.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import Firebase
import AlamofireImage
import FirebaseCore
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        window = UIWindow(frame: UIScreen.main.bounds)
        sleep(3)
//        FirebaseApp.configure()
//        GIDSignIn.sharedInstance.clientID = "330854842489-c25b86f35mmp4ckogq99l06tn52jj4ki.apps.googleusercontent.com"
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
                let vc = storyBoard.instantiateViewController(identifier:"LoginVC") as! LoginVC
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.setNavigationBarHidden(true, animated: true)
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
    func dropDown(dataSource:[String] , text:UIView , completion: @escaping ( _ index: Int ,    _ item: String) -> ()) -> Void {
                                        let dropDown = DropDown()
                                        dropDown.anchorView = text
                                        dropDown.dataSource = dataSource
                                        dropDown.backgroundColor = UIColor.white
                                        dropDown.textColor = .black
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
}

