//
//  LogOutVC.swift
//  Dawadawa
//
//  Created by Alekh on 23/06/22.
//

import UIKit

class LogOutVC: UIViewController {
    
    var callbacklogout:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.callbacklogout?("Cancel")
      
}

    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        self.callbacklogout?("Logout")
    }
    
}
