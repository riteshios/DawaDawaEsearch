//  LogOutVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 23/06/22.

import UIKit

class LogOutVC: UIViewController {
    
    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    @IBOutlet weak var lblSecondLogout: UILabel!
    
    @IBOutlet weak var btnLogOut: UIButton!
    var callbacklogout:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.languagesetup()
    }
    
//    MARK: - @IBAction
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
//        self.callbacklogout?("Cancel")
        self.dismiss(animated: true)
}
  
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        
        UserData.shared.saveData(data: [:], token: "" )
        print("\(UserData.shared.saveData(data: [:], token: "" ))")
        
        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: [:])
        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: "")
        print("token---", kSharedUserDefaults.getLoggedInAccessToken())
        print("tetaild---", kSharedUserDefaults.getLoggedInUserDetails())
        print("\(kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: ""))")
            self.callbacklogout?("Logout")
    }
}
// MARK: - Localisation

extension LogOutVC{
    func languagesetup(){
        lblLogout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Logout", comment: "")
        lblSubHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Do you really want to log out?", comment: "")
        lblCancel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancel", comment: "")
        lblSecondLogout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Logout", comment: "")
    }
}

//extension UIViewController{
//    func logout(){
//        UserData.shared.saveData(data: [:], token: "" )
//        print("\(UserData.shared.saveData(data: [:], token: "" ))")
//       print("id---", UserData.shared.id)
//        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: [:])
//        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: "")
//        print("token---", kSharedUserDefaults.getLoggedInAccessToken())
//        print("tetaild---", kSharedUserDefaults.getLoggedInUserDetails())
//
//        print("\(kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: ""))")
//    }
//}
 
