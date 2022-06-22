//
//  AppDelegate.swift
//  Dawadawa
//
//  Created by Alekh Verma on 09/06/22.
//

import UIKit
import DropDown
import AlamofireImage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
 
    func dropDown(dataSource:[String] ,img:UIImage? , text:UIView , completion: @escaping (   _ index: Int ,   _ item: String , _ item1: UIImage) -> ()) -> Void {
                                     let dropDown = DropDown()
                                     dropDown.anchorView = text
                                     dropDown.dataSource = dataSource
                                     dropDown.img = img
                                     dropDown.backgroundColor = UIColor.white
                                     dropDown.textColor = .black
                                     dropDown.width = text.frame.size.width
                                     dropDown.direction = .bottom
                                     dropDown.selectionBackgroundColor = UIColor.white
                                     dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
                                     dropDown.dismissMode = .onTap
                                     dropDown.show()
                                     dropDown.selectionAction = {(index: Int, item: String, item1: UIImage) in
                                         print("Selected item: \(item) at index: \(index)")
                                         completion(index,item,item1)
                                 }
                     }
           
}

