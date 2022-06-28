//
//  VerifyEmailOTPVC.swift
//  Dawadawa
//
//  Created by Alekh on 28/06/22.
//

import UIKit

class VerifyEmailOTPVC: UIViewController {

    @IBOutlet weak var lblWrongCode: UILabel!
    var callbackOTP1:(()->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblWrongCode.isHidden = true
    }
    
    @IBAction func BtnVerifyTapped(_ sender: UIButton) {
        self.callbackOTP1?()
    }
    
    

}
