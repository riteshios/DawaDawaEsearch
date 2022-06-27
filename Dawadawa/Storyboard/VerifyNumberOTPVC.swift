//
//  VerifyNumberOTPVC.swift
//  Dawadawa
//
//  Created by Alekh on 27/06/22.
//

import UIKit

class VerifyNumberOTPVC: UIViewController {
    var callbackOTP1:(()->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func btnVerifyTapped(_ sender: UIButton) {
        self.callbackOTP1?()
    }
    
   

}
