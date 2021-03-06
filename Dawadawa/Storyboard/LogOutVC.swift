//
//  LogOutVC.swift
//  Dawadawa
//
//  Created by Alekh on 23/06/22.
//

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
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
//        self.callbacklogout?("Cancel")
        self.dismiss(animated: true)
}
  
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        UserData.shared.saveData(data: [:], token: "" )
        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: [:])
        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: "")
        print("\(kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: ""))")
            self.callbacklogout?("Logout")
    }
}

extension LogOutVC{
    func languagesetup(){
        lblLogout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Logout", comment: "")
        lblSubHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Do you really want to log out?", comment: "")
        lblCancel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancel", comment: "")
        lblSecondLogout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Logout", comment: "")
    }
}
