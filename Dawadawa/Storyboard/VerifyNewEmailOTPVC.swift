//
//  VerifyNewEmailOTPVC.swift
//  Dawadawa
//
//  Created by Alekh on 28/06/22.
//

import UIKit

class VerifyNewEmailOTPVC: UIViewController {
    @IBOutlet weak var lblWrongCode: UILabel!
    var callbackOTP2:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.lblWrongCode.isHidden = true
    }
    
    @IBAction func btnVerifyTapped(_ sender: UIButton) {
        self.callbackOTP2?()
    }
    

}
