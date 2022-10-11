//
//  VerifyNumberOTPVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 27/06/22.
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
//extension VerifyEmailOTPVC: UITextFieldDelegate{
//    func textFieldDidBeginEditing(_ textField: UITextField){
//        switch textField{
//        case self.txtfieldOtp1:
//            self.viewOtp1.borderColor = UIColor(hexString: "#1572A1")
//            //            self.textFieldPhoneNumber.textColor = UIColor(hexStrin
//
//        case self.txtfieldOtp2:
//            self.viewOtp2.borderColor = UIColor(hexString: "#1572A1")
//
//        case self.txtfieldOtp3:
//            self.viewOtp3.borderColor = UIColor(hexString: "#1572A1")
//
//        case self.txtfieldOtp4:
//            self.viewOtp4.borderColor = UIColor(hexString: "#1572A1")
//
//        case self.txtfieldOtp5:
//            self.viewOtp5.borderColor = UIColor(hexString: "#1572A1")
//
//        case self.txtfieldOtp6:
//            self.viewOtp6.borderColor = UIColor(hexString: "#1572A1")
//
//        default:
//            return
//        }
//    }
//}
