//
//  ChangePasswordOTPVerifyVC.swift
//  Dawadawa
//
//  Created by Alekh on 28/06/22.
//

import UIKit

class ChangePasswordOTPVerifyVC: UIViewController {
    
    var callbackotp:(()->())?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnVerifyOtpTaooed(_ sender: UIButton) {
        self.callbackotp?()
        
    }
    

}
