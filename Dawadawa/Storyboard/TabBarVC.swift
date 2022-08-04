//
//  TabBarVC.swift
//  Dawadawa
//
//  Created by Alekh on 20/06/22.
//

import UIKit
import STTabbar

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let myTabbar = tabBar as? STTabbar {
            myTabbar.centerButtonActionHandler = {
                print("Center Button Tapped")
                
                if UserData.shared.isskiplogin == true{
                    self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                }
                else{
                let vc = self.storyboard!.instantiateViewController(withIdentifier: SelectCategoryVC.getStoryboardID()) as! SelectCategoryVC
                self.navigationController?.pushViewController(vc, animated: true)
                
                }
            }
        }
    }
    

    
    

}
