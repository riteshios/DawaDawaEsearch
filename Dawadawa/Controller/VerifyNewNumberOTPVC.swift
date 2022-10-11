//
//  VerifyNewNumberOTPVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 27/06/22.
//

import UIKit

class VerifyNewNumberOTPVC: UIViewController {

    var callbackOTP2:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnVerifyTapped(_ sender: UIButton) {
        self.callbackOTP2?()
        
    }
    
   

}
