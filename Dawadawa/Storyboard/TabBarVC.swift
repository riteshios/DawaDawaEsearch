//  TabBarVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 20/06/22.

import UIKit
import STTabbar

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if let myTabbar = tabBar as? STTabbar {
            myTabbar.centerButtonActionHandler = {
                print("Center Button Tapped")
                
                if UserData.shared.isskiplogin == true{
                    if kSharedUserDefaults.getlanguage() as? String == "en"{
                        self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                    }
                    else{
                        self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                    }
                }
                else{
                    if UserData.shared.user_type == "0"{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "This feature is not available for Investor")
                        }
                        else{
                            self.showSimpleAlert(message: "هذه الميزة غير متاحة للمستثمر")
                        }
                        
                    }
                    else{
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: SelectCategoryVC.getStoryboardID()) as! SelectCategoryVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
    }
}
    

